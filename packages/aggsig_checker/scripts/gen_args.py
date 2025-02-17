from nostr.key import PublicKey
from garaga.definitions import CurveID, G1Point, CURVES
from garaga.starknet.tests_and_calldata_generators.signatures import SchnorrSignature
from hashlib import sha256
import sys
import json

TWO128 = 2**128


def generate_args(events: list[dict], target: str) -> list:
    args_list = list(map(handle_event, events))
    res = [len(args_list)] + [item for sublist in args_list for item in sublist]
    
    if target == "cairo-run":
        return [res]
    elif target == "execute":
        return [hex(len(res))] + list(map(hex, res))
    else:
        raise NotImplementedError(target)


def to_u256(value: int) -> list[int]:
    return [value % TWO128, value // TWO128]


def hash_challenge(rx: int, px: int, msg: int) -> int:
    tagged_hash = sha256("BIP0340/challenge".encode()).digest()
    input = tagged_hash + tagged_hash + rx.to_bytes(32, "big") + px.to_bytes(32, "big") + msg.to_bytes(32, "big")
    return int.from_bytes(sha256(input).digest(), "big")


def derive_point_from_x(x, is_even):
    """
    Derive the EC point (x, y) from an x-coordinate on the secp256k1 curve.
    :param x: The x-coordinate (integer).
    :param is_even: Boolean indicating whether y should be even.
    :return: Tuple (x, y) representing the EC point.
    """
    p = CURVES[CurveID.SECP256K1.value].p
    a = CURVES[CurveID.SECP256K1.value].a
    b = CURVES[CurveID.SECP256K1.value].b
    
    # Calculate y^2 = x^3 + ax + b mod p
    y_squared = (pow(x, 3, p) + a * x + b) % p
    
    # Compute modular square root of y^2 mod p
    # Using pow(y_squared, (p+1)//4, p) because p ≡ 3 mod 4
    y = pow(y_squared, (p + 1) // 4, p)
    
    # Select the correct y based on its parity (even/odd)
    if is_even != (y % 2 == 0):
        y = p - y
    
    return (x, y)


def handle_event(event: dict) -> dict:
    """
    Generate the arguments for the Cairo program from a Nostr event.
    """
    pubkey = PublicKey.from_npub(event["nostr_event"]["pubkey"])
    px = int.from_bytes(pubkey.raw_bytes, "big")
    _, py = derive_point_from_x(px, is_even=True)

    sig = bytes.fromhex(event["nostr_event"]["sig"])
    rx = int.from_bytes(sig[:32], "big")
    s = int.from_bytes(sig[32:], "big")

    msg = int.from_bytes(bytes.fromhex(event["nostr_event"]["id"]), "big")
    
    n = CURVES[CurveID.SECP256K1.value].n
    e = hash_challenge(rx, px, msg) % n

    signature = SchnorrSignature(
        rx,
        s,
        e,
        px,
        py,
        curve_id=CurveID.SECP256K1
    )

    # print(f"m: {msg}", file=sys.stderr)
    # print(f"rx: {rx}", file=sys.stderr)
    # print(f"s: {s}", file=sys.stderr)
    # print(f"e: {e}", file=sys.stderr)
    # print(f"px: {px}", file=sys.stderr)
    # print(f"py: {py}", file=sys.stderr)

    return [
        *to_u256(msg),
        *signature.serialize_with_hints(),
    ]


if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python gen_args.py [--file <path_to_events_file>] [--target <cairo-run|execute>]")
        sys.exit(1)
    
    if sys.argv[1] == "--file":
        with open(sys.argv[2], "r") as f:
            events = json.load(f)
    else:
        events = json.load(sys.stdin)

    if sys.argv[3] == "--target":
        target = sys.argv[4]
    else:
        target = "cairo-run"

    args = generate_args(events, target)
    print(json.dumps(args, indent=2))
