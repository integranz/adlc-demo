import { describe, it, expect } from "vitest";
import { sameRelease } from "./version.js";

describe("sameRelease", () => {
  it("ignores build metadata", () => { expect(sameRelease("1.2.3", "1.2.3+abc123")).toBe(true); });
  it("differs on different versions", () => { expect(sameRelease("1.2.3", "1.2.4")).toBe(false); });
  it("is false for empty input", () => { expect(sameRelease("", "")).toBe(false); });
});
