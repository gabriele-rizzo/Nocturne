export const url = (path: string) =>
    /^(https?:|mailto:)/.test(path) ? path : `${import.meta.env.BASE_URL}/${path}`.replace(/\/{2,}/g, "/");
