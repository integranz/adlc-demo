import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";

// VERSION is injected at build time (CI: --build-arg VERSION -> VITE_APP_VERSION). Falls back to 0.0.0-local.
export default defineConfig({
  plugins: [react()],
  define: { __APP_VERSION__: JSON.stringify(process.env.VITE_APP_VERSION || "0.0.0-local") },
  server: { port: 5173, proxy: { "/api": { target: "http://localhost:8080", changeOrigin: true } } },
  build: { outDir: "dist", sourcemap: false },
  test: { environment: "node" },
});
