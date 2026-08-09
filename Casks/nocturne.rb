cask "nocturne" do
  version "1.2.1"
  sha256 "fec12fbd530ec12051e61e35228b0e54f409d8a9451a48ec36801bb3aed5df60"

  url "https://github.com/gabriele-rizzo/Nocturne/releases/download/v#{version}/Nocturne.dmg",
      verified: "github.com/gabriele-rizzo/Nocturne/"
  name "Nocturne"
  desc "Turns the built-in keyboard backlight off on a schedule"
  homepage "https://github.com/gabriele-rizzo/Nocturne"

  auto_updates true
  depends_on macos: :sequoia

  app "Nocturne.app"

  zap trash: "~/Library/Preferences/gabrielerizzo.Nocturne.plist"
end
