{ ... }: {
  flake.modules.nixos.locale = { ... }: {
    time.timeZone = "Europe/Copenhagen";
    i18n.defaultLocale = "en_US.UTF-8";
    console.keyMap = "dk";
  };
}
