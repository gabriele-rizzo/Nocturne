// @ts-check
import tailwindcss from "@tailwindcss/vite";
import icon from "astro-icon";
import { defineConfig } from "astro/config";

// https://astro.build/config
export default defineConfig({
    site: "https://gabriele-rizzo.github.io",
    base: "/Nocturne",
    integrations: [icon()],
    output: "static",
    vite: { plugins: [tailwindcss()] },
});
