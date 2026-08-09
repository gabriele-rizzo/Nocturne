import { execSync } from "node:child_process";

const run = (command: string) => execSync(command, { encoding: "utf8", stdio: ["ignore", "pipe", "ignore"] }).trim();

let cached: Release[] | null = null;

export function releases(): Release[] {
    if (cached) return cached;

    let tags: string[] = [];
    try {
        tags = run("git tag --list 'v[0-9]*' --sort=-version:refname").split("\n").filter(Boolean);
    } catch {
        return (cached = []);
    }

    cached = tags.map((tag) => ({
        tag,
        version: tag.replace(/^v/, ""),
        date: run(`git log -1 --format=%cs ${tag}`),
        notes: run(`bash ../Scripts/release-notes.sh ${tag}`).split("\n").filter(Boolean),
    }));

    return cached;
}

export const latest = (): Release | undefined => releases()[0];
