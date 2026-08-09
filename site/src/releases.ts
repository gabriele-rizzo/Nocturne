import { execSync } from "node:child_process";

const git = (args: string[]) => execSync(["git", ...args].join(" "), { encoding: "utf8", stdio: ["ignore", "pipe", "ignore"] }).trim();

const noise = /^(Bump the version|Point the cask at)/;

let cached: Release[] | null = null;

export function releases(): Release[] {
    if (cached) return cached;

    let tags: string[] = [];
    try {
        tags = git(["tag", "--list", "'v[0-9]*'", "--sort=-version:refname"]).split("\n").filter(Boolean);
    } catch {
        return (cached = []);
    }

    cached = tags.map((tag) => {
        let previous = "";
        try {
            previous = git(["describe", "--tags", "--abbrev=0", "--match", "'v[0-9]*'", `${tag}^`]);
        } catch {}

        const range = previous ? `${previous}..${tag}` : tag;
        const notes = git(["log", "--no-merges", "--format=%s", range])
            .split("\n")
            .filter((line) => line && !noise.test(line));

        return {
            tag,
            version: tag.replace(/^v/, ""),
            date: git(["log", "-1", "--format=%cs", tag]),
            notes: notes.length ? notes : ["Maintenance and fixes."],
        };
    });

    return cached;
}

export const latest = (): Release | undefined => releases()[0];
