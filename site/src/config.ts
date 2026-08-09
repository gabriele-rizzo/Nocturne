export const identity: Identity = {
    name: "Nocturne",
    tagline: "Your keyboard backlight, on a schedule.",
    repo: "https://github.com/gabriele-rizzo/Nocturne",
};

export const navBarLinks: NavBarLink[] = [
    {
        title: "Home",
        url: "/",
    },
    {
        title: "Changelog",
        url: "/changelog",
    },
    {
        title: "GitHub",
        url: identity.repo,
        external: true,
    },
];

export const socialLinks: SocialLink[] = [
    {
        title: "GitHub",
        url: identity.repo,
        icon: "mdi:github",
        external: true,
    },
    {
        title: "Buy me a coffee",
        url: "https://www.buymeacoffee.com/gabrielerizzo",
        icon: "mdi:coffee",
        external: true,
    },
];

export const homePageContent: HomePageContent = {
    seo: {
        title: "Nocturne — Your keyboard backlight, on a schedule",
        description:
            "A small macOS menu bar app that turns the built-in keyboard backlight off when you don't need it: all day, on a schedule you set, or from sunrise to sunset wherever you are.",
    },
    description:
        "Nocturne is a small menu bar app that turns the built-in keyboard backlight off when you don't need it: all day, on a schedule you set, or from sunrise to sunset wherever you are. It hands it back untouched when you're done.",
    requirement: "macOS 15.7 or later",
    gatekeeper:
        "Nocturne isn't notarized, so macOS blocks it the first time you open it. Open System Settings, go to Privacy & Security, and scroll to the security section: there's a line saying Nocturne was blocked, with an Open Anyway button next to it. You only do this once, and updates install without asking again.",
    homebrew: [
        "brew tap gabriele-rizzo/nocturne https://github.com/gabriele-rizzo/Nocturne",
        "brew trust gabriele-rizzo/nocturne",
        "brew install --cask nocturne",
    ],
    schedules: [
        {
            title: "Always on",
            description: "Nocturne stays out of the way and the backlight behaves normally.",
        },
        {
            title: "Always off",
            description: "The backlight stays off.",
        },
        {
            title: "Sunset to sunrise",
            description:
                "The backlight is off during daylight and comes back when it gets dark. Uses civil twilight, so it switches when it's actually dark rather than at the moment the sun crosses the horizon.",
        },
        {
            title: "Custom",
            description:
                "Pick the hours the backlight should be off. Windows that run past midnight are fine, so 22:00 to 07:00 works as you'd expect.",
        },
    ],
    features: [
        {
            title: "Pause for an Hour",
            description:
                "Puts the schedule aside and gives the backlight back for an hour, for when you need to see the keys right now. The schedule picks up again on its own when the hour is up.",
        },
        {
            title: "Prevent Dimming",
            description:
                "Stops macOS from fading the keyboard backlight after a minute of inactivity. It's off by default, and Nocturne puts your original setting back when it quits.",
        },
        {
            title: "Launch at Login",
            description: "Starts Nocturne automatically. macOS may ask you to approve it in System Settings the first time.",
        },
        {
            title: "Nothing leaves your Mac",
            description:
                "Sunset to sunrise needs your location to work out when the sun rises and sets. Nocturne only ever computes those times locally, and nothing is sent anywhere.",
        },
    ],
    updates:
        "Nocturne updates itself in place, so there is nothing to drag into your Applications folder a second time. It won't check on its own until you say it can, and every release is signed with a key that only the project holds.",
};

export const changelogPageContent: ChangelogPageContent = {
    seo: {
        title: "Changelog | Nocturne",
        description: "What changed in each release of Nocturne.",
    },
    subtitle: "What changed in each release.",
};
