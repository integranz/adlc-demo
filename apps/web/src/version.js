// Web version comes from the build (__APP_VERSION__ is defined by vite.config.js).
export const webVersion = typeof __APP_VERSION__ === "string" ? __APP_VERSION__ : "0.0.0-local";

// Compare two versions loosely: "1.2.3" vs "1.2.3+sha" are the same release.
export function sameRelease(a, b) {
  const strip = (v) => String(v ?? "").split("+")[0].trim();
  return strip(a) !== "" && strip(a) === strip(b);
}
