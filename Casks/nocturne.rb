cask "nocturne" do
  version "1.1.5"
  sha256 "79248e5f8d3332b4754ab0e23c232701e1f0fd57b5f4c000f1112211eb0a8275"

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
