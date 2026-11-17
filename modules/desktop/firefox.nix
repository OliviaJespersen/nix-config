{ ... }: {
  flake.modules.homeManager.firefox = { ... }: {
    programs.firefox = {
      enable = true;
      configPath = ".mozialla/firefox";
      policies = {
        DisableFirefoxAccounts = true;
        Homepage.StartPage = "previous-session";
        ExtensionSettings = {
          "*".installation_mode = "blocked";
          "uBlock0@raymondhill.net" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
            installation_mode = "force_installed";
            updates_disabled = true;
          };
        };
      };
      profiles.default.settings = {
        "sidebar.main.tools" = [];
        "sidebar.verticalTabs" = true;
      };
    };
  };
}
