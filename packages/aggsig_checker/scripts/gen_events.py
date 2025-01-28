from nostr.event import Event
from nostr.key import PrivateKey
import sys
import json

def create_events(n: int) -> list[Event]:
    events = []
    for i in range(n):
        private_key = PrivateKey()
        pubkey = private_key.public_key.bech32()
        event = Event(content=f"Hello Nostr {i}", public_key=pubkey)
        private_key.sign_event(event)
        events.append({
            "nostr_event": {
                "id": event.id,
                "pubkey": event.public_key,
                "created_at": event.created_at,
                "kind": event.kind,
                "tags": event.tags,
                "content": event.content,
                "sig": event.signature
            },
        })
    return events


if __name__ == "__main__":
    n = int(sys.argv[1]) if len(sys.argv) > 1 else 1
    print(json.dumps(create_events(n), indent=2))
