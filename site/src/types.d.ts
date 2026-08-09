interface NavBarLink {
    title: string;
    url: string;
    external?: boolean;
}

interface SocialLink {
    title: string;
    url: string;
    icon: string;
    external?: boolean;
}

interface Identity {
    name: string;
    tagline: string;
    repo: string;
}

interface SEOInfo {
    title: string;
    description: string;
}

interface Schedule {
    title: string;
    description: string;
}

interface Feature {
    title: string;
    description: string;
}

interface HomePageContent {
    seo: SEOInfo;
    description: string;
    requirement: string;
    gatekeeper: string;
    homebrew: string[];
    schedules: Schedule[];
    features: Feature[];
    updates: string;
}

interface ChangelogPageContent {
    seo: SEOInfo;
    subtitle: string;
}

interface Release {
    tag: string;
    version: string;
    date: string;
    notes: string[];
}
