{ inputs, ... }: {
  flake.modules.homeManager.firefox = { config, ... }: {
    imports = [
      inputs.textfox.homeManagerModules.default
    ];

    textfox = {
      enable = true;
      profiles = [ "default" ];
      config = {
        displaySidebarTools = false;
        font.family = "Maple Mono NF";
        tabs.vertical.enable = true;
      };
    };

    programs.firefox = {
      enable = true;
      configPath = "${config.xdg.configHome}/mozilla/firefox";
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
          "{6bbdb3f9-6bd5-4385-9087-e293ec8d21a4}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/file/3847671/rose_pine-1.0.xpi";
            installation_mode = "force_installed";
            updates_disabled = true;
          };
        };
      };
      profiles.default.settings = {
        "ui.systemUsesDarkTheme" = 1;
      };
    };
  };
}
