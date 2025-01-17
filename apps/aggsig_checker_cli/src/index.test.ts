import { splitToU128Pair } from "./index";

describe("splitToU128Pair", () => {
  it("should correctly split a hex string into low and high u128 values", () => {
    const hexStr =
      "1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef";
    const result = splitToU128Pair(hexStr);

    expect(result).toHaveProperty("low");
    expect(result).toHaveProperty("high");
    expect(typeof result.low).toBe("string");
    expect(typeof result.high).toBe("string");
  });

  it("should handle shorter hex strings by padding", () => {
    const hexStr = "abcdef";
    const result = splitToU128Pair(hexStr);

    expect(result.low).toBe(BigInt("0x" + "abcdef").toString());
    expect(result.high).toBe("0");
  });

  it("should handle hex strings with 0x prefix", () => {
    const hexStr = "0x1234567890abcdef";
    const result = splitToU128Pair(hexStr);

    expect(result.low).toBe(BigInt("0x1234567890abcdef").toString());
    expect(result.high).toBe("0");
  });
});
