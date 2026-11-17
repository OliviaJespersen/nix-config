# AGENTS.md — Nix Configuration Guidelines

## Purpose

This document provides architectural guidelines and coding conventions for AI assistants working on this Nix configuration.

The goal is to maintain a clean, modular, understandable configuration for a small number of machines, without unnecessary abstractions.

**Follow the existing architecture and conventions. Do not introduce new architectural patterns without an explicit request.**

When this document conflicts with assumptions about how Nix configurations are typically organized, prefer this document.

## 1. Architecture

This repository uses the **Dendritic Nix pattern**, built around:

- Nix flakes
- `flake-parts`
- `import-tree`
- Typed `flake.modules`
- NixOS
- Home Manager

### Core principles

1. **Organize by feature, not module system.** Related NixOS and Home Manager configurations belong together.
2. **One conceptual feature per module.** A feature may export multiple module types.
3. **Keep host composition explicit.** Each host defines its own flake configuration and chooses which features to import.
4. **Separate module definition from activation.** Discovering a module must not automatically enable it.
5. **Prefer simple, readable Nix.** Avoid abstractions that don't solve an existing problem.
6. **Keep the architecture lightweight.** The repository only needs to support a few machines.

### Decisions already made

| Concern | Decision |
|---|---|
| Architecture | Full Dendritic |
| Module discovery | `import-tree` |
| Flake composition | `flake-parts` |
| Module exports | `flake.modules.<class>.<name>` |
| Organization | Feature-oriented |
| NixOS and Home Manager | May be defined together in one file |
| Host definitions | Each host owns its configuration output |
| Feature activation | Explicit imports |
| Profiles | Do not introduce |
| Custom host constructors | Do not introduce |
| Automatic feature activation | Do not introduce |

These choices are intentional. Do not replace them with conventional NixOS or Home Manager directory trees.

## 2. Directory structure

The intended layout is:

```text
.
├── AGENTS.md
├── flake.nix
├── flake.lock
└── modules/
    ├── flake-parts.nix
    │
    ├── hosts/
    │   ├── laptop/
    │   │   ├── default.nix
    │   │   └── _hardware.nix
    │   └── desktop/
    │       ├── default.nix
    │       └── _hardware.nix
    │
    ├── programs/
    │   ├── git.nix
    │   ├── neovim.nix
    │   ├── fish.nix
    │   └── firefox.nix
    │
    ├── desktop/
    │   ├── niri.nix
    │   ├── waybar.nix
    │   └── theming.nix
    │
    ├── services/
    │   ├── ssh.nix
    │   └── syncthing.nix
    │
    └── system/
        ├── nix.nix
        ├── locale.nix
        └── fonts.nix
```

This structure is illustrative. Actual host names and available features are determined by the repository.

### Directory responsibilities

**`modules/hosts/`**

Host-specific configuration and flake outputs. Each host explicitly imports the features it requires.

**`modules/programs/`**

Applications, shells, editors, terminal tools, and other programs. A file may define both NixOS and Home Manager modules.

**`modules/desktop/`**

Graphical environment features, window managers, compositors, bars, notifications, and appearance settings.

**`modules/services/`**

System services, network services, and background processes.

**`modules/system/`**

General operating-system settings such as Nix, locale, fonts, and system-wide configuration.

**`modules/flake-parts.nix`**

Shared flake-parts initialization, including the typed module system.

### Directory rules

- Prefer existing directories over creating new categories.
- Add a directory only when it improves organization.
- Avoid unnecessary nesting.
- Do not create separate `nixos/` and `home-manager/` feature trees.
- Do not add a `profiles/` directory.
- Do not create a directory for every individual feature unless its complexity warrants it.

A simple feature should usually be a single `.nix` file.

## 3. Flake structure

The root `flake.nix` should remain minimal.

Example:

```nix
{
  description = "Dendritic Nix configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";

    import-tree.url = "github:vic/import-tree";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake
      { inherit inputs; }
      (inputs.import-tree ./modules);
}
```

The repository's actual input revisions and release branches take precedence over this example.

### Rules

- Use `flake-parts` for flake composition.
- Use `import-tree` to discover modules.
- Avoid manually registering every feature in `flake.nix`.
- Do not place host-specific configuration in `flake.nix`.
- Do not turn `flake.nix` into a centralized host constructor.
- Prefer defining flake outputs within their relevant modules.

The expected flake-parts initialization is:

```nix
# modules/flake-parts.nix
{ inputs, ... }: {
  imports = [
    inputs.flake-parts.flakeModules.modules
  ];

  systems = [
    "x86_64-linux"
  ];
}
```

The `systems` list is illustrative and should include only the architectures required by the actual configuration.

## 4. Feature modules

A feature is a self-contained unit of configuration representing a program, service, or functionality.

**Features are organized by their purpose, not by whether their settings belong to NixOS or Home Manager.**

### Defining multiple module types

A single file may export both NixOS and Home Manager modules:

```nix
# modules/programs/git.nix
{ ... }: {
  flake.modules.nixos.git = { ... }: {
    programs.git.enable = true;
  };

  flake.modules.homeManager.git = { ... }: {
    programs.git = {
      enable = true;

      settings = {
        init.defaultBranch = "main";
        pull.rebase = true;
      };
    };
  };
}
```

This is the preferred pattern when a feature requires both system-level and user-level configuration.

### System-level and user-level concerns

Place settings in the appropriate module system.

Typical NixOS responsibilities:

- System services
- Hardware support
- System-wide packages
- System permissions
- System-wide shell aliases
- Operating system integration

Typical Home Manager responsibilities:

- User programs
- Dotfiles
- Editor settings
- User shell configuration
- Application preferences
- User-specific packages

For example:

```nix
# modules/programs/fastfetch.nix
{ ... }: {
  flake.modules.nixos.fastfetch = { ... }: {
    environment.shellAliases = {
      ff = "fastfetch";
    };
  };

  flake.modules.homeManager.fastfetch = { ... }: {
    programs.fastfetch.enable = true;
  };
}
```

This demonstrates configuring a program through Home Manager while also defining a system-wide alias through NixOS.

**Important:** `environment.shellAliases` is system-wide, while a package installed by Home Manager is user-specific. Do not assume the alias's target command is available to all users. When an alias should only apply to one user, prefer a Home Manager alias instead.

### Not every feature needs multiple module types

A purely NixOS feature may export only:

```nix
{ ... }: {
  flake.modules.nixos.ssh = { ... }: {
    services.openssh.enable = true;
  };
}
```

A purely Home Manager feature may export only:

```nix
{ ... }: {
  flake.modules.homeManager.neovim = { ... }: {
    programs.neovim.enable = true;
  };
}
```

Do not create empty modules simply to maintain symmetry.

### Module naming

Prefer descriptive, consistent names.

Example:

```nix
flake.modules.nixos.git
flake.modules.homeManager.git

flake.modules.nixos.niri
flake.modules.homeManager.niri
```

Use the same name across module systems when the modules represent the same feature.

Avoid collisions between unrelated features.

## 5. Module discovery versus activation

`import-tree` automatically imports flake-parts module definitions from `modules/`.

**Automatic discovery must not mean automatic feature activation.**

For example, creating:

```text
modules/programs/git.nix
```

makes its exported modules available through:

```nix
config.flake.modules.nixos.git
config.flake.modules.homeManager.git
```

It does not mean Git should be enabled on every host.

The host must explicitly select the relevant modules.

### Important distinction

These are separate operations:

1. Importing a flake-parts module so its feature definitions are available.
2. Importing one of those feature modules into an actual NixOS or Home Manager configuration.

Do not conflate them.

### Avoid automatic enablement

Do not introduce mechanisms that automatically enable all discovered features.

Do not introduce custom options such as:

```nix
my.features.git.enable = true;
```

unless there is a concrete need for them and the user has approved the abstraction.

Prefer standard Nix module composition through `imports`.

## 6. Host configuration

Each host should define its own flake output.

This is an intentional architectural decision.

Do not centralize all host definitions inside `flake.nix` or introduce a generic host factory.

A host directory may contain:

```text
modules/hosts/laptop/
├── default.nix
└── _hardware.nix
```

The `default.nix` file is a flake-parts module.

The `_hardware.nix` file is a conventional NixOS module excluded from automatic discovery.

### Example host

```nix
# modules/hosts/laptop/default.nix
{ config, inputs, ... }:
let
  inherit (config.flake.modules) nixos homeManager;
in
{
  flake.nixosConfigurations.laptop =
    inputs.nixpkgs.lib.nixosSystem {
      modules = [
        nixos.laptop
      ];
    };

  flake.modules.nixos.laptop = { ... }: {
    imports = [
      ./_hardware.nix

      nixos.git
      nixos.fastfetch

      inputs.home-manager.nixosModules.home-manager
    ];

    networking.hostName = "laptop";

    nixpkgs.hostPlatform = "x86_64-linux";

    users.users.alice = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
    };

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;

      users.alice = { ... }: {
        imports = [
          homeManager.git
          homeManager.fastfetch
          homeManager.neovim
        ];

        home.username = "alice";
        home.homeDirectory = "/home/alice";
        home.stateVersion = "24.11";
      };
    };

    system.stateVersion = "24.11";
  };
}
```

This example illustrates composition only. Real host configuration must use the correct hardware, architecture, username, and state versions.

### Host composition rules

- Each host defines its own `flake.nixosConfigurations.<hostname>`.
- Each host exports its own `flake.modules.nixos.<hostname>`.
- Each host explicitly imports required NixOS features.
- Each Home Manager user explicitly imports required Home Manager features.
- Keep machine-specific settings in the host.
- Keep reusable behavior in feature modules.
- Do not assume all hosts use the same applications or services.

Avoid repeating substantial reusable feature implementations inside multiple hosts.

Small amounts of duplication in explicit imports are acceptable.

**Readability is more important than eliminating every repeated line.**

## 7. Home Manager integration

Home Manager is integrated into NixOS through its NixOS module for hosts using that deployment model.

Feature files may export Home Manager modules independently of how they are deployed.

### Rules

- Define reusable Home Manager behavior through `flake.modules.homeManager.<feature>`.
- Import Home Manager features explicitly for each relevant user.
- Do not automatically enable all Home Manager features.
- Do not make a NixOS feature implicitly enable its Home Manager counterpart.
- Do not assume every host has only one user.
- Do not assume a program installed through Home Manager is globally available.
- Do not create standalone Home Manager configurations unless required.

The NixOS and Home Manager parts of a feature should remain independently importable.

If standalone Home Manager is introduced later, reuse existing feature modules rather than duplicating them.

## 8. Helper files and automatic imports

By default, `import-tree` ignores paths containing an underscore-prefixed component.

This convention separates flake-parts modules from files that should not be imported automatically.

For example:

```text
modules/hosts/laptop/
├── default.nix
└── _hardware.nix
```

Here:

- `default.nix` is discovered by `import-tree`.
- `_hardware.nix` is not.
- The host explicitly imports `_hardware.nix`.

The same principle applies to other support files.

Example:

```text
modules/programs/neovim/
├── default.nix
├── _settings.nix
└── _keymaps.nix
```

### Rules

- Every automatically discovered Nix file under `modules/` must be a valid flake-parts module.
- Prefix conventional helper files or helper directories with `_`.
- Never place ordinary NixOS modules directly in the auto-imported tree without excluding them.
- Keep helper files near the feature using them.
- Prefer simple inline configuration before splitting a small feature across many files.

If the repository changes its import-tree filtering behavior, inspect that implementation rather than relying blindly on these conventions.

## 9. No profiles for now

This repository intentionally does not use profiles.

Do not create abstractions such as:

```text
modules/profiles/
├── base.nix
├── desktop.nix
├── development.nix
└── server.nix
```

Do not introduce bundles of features solely to avoid a few repeated imports.

Instead, hosts should explicitly import their required features.

### Why?

The configuration supports only a few machines.

Explicit imports make it easier to understand exactly what is enabled on each machine.

Some repetition is acceptable.

Profiles may become useful if several hosts repeatedly share large groups of features, but that decision should be revisited only when there is an actual maintenance problem.

**Do not introduce profiles proactively.**

## 10. Keeping configuration simple

Prefer the simplest implementation that fits the architecture.

### Avoid unnecessary abstractions

Do not introduce the following without a demonstrated need:

- Custom host constructors
- Feature registries
- Automatic feature activation
- Configuration profiles
- Large global variable sets
- Custom enable-option frameworks
- Generic module factories
- Unnecessary overlays
- Additional module-management frameworks

Do not introduce `den`, `ez-configs`, or similar frameworks simply because they support Dendritic configurations.

The existing flake-parts and import-tree architecture should be sufficient.

### Prefer ordinary Nix constructs

Use:

- `imports`
- `let ... in`
- Standard module options
- `lib.mkIf` when conditional configuration is needed
- `lib.mkDefault` when a value should remain overridable
- Typed custom options when there is a genuine shared-configuration requirement

Avoid custom helpers that obscure standard NixOS or Home Manager behavior.

### Use abstractions only when justified

If a change would benefit from a new abstraction, explain:

1. What concrete problem it solves.
2. Why existing Nix module mechanisms are insufficient.
3. What additional complexity it introduces.

Do not implement architectural changes without approval.

## 11. Editing existing configuration

Before changing files:

1. Inspect the existing relevant feature and host modules.
2. Understand how the feature is currently activated.
3. Identify which module system owns the relevant settings.
4. Check whether there is already a reusable feature module.
5. Preserve existing configuration unless the requested change requires modifying it.

### When adding a new program

1. Look for an existing feature file.
2. If none exists, create one under the appropriate directory.
3. Define its NixOS and/or Home Manager modules.
4. Keep system and user configuration together when related.
5. Add explicit imports to the appropriate hosts and users.
6. Validate the affected configurations.

Do not enable the feature on unrelated hosts.

### When modifying a program

Modify its existing feature module rather than creating another module containing overlapping configuration.

### When adding a host

1. Create a new host module under `modules/hosts/`.
2. Add hardware-specific files as excluded helpers.
3. Define the host's flake configuration output.
4. Explicitly select its required features.
5. Configure Home Manager users where appropriate.
6. Validate the new host.

Do not restructure existing hosts simply to accommodate the new one.

### When removing a feature

Remove relevant imports from hosts and users.

Check for dependencies before deleting the feature module.

Avoid unintentionally removing configuration shared with other hosts.

## 12. Configuration ownership

Choose the correct location for each setting.

| Setting | Preferred location |
|---|---|
| Git configuration | `modules/programs/git.nix` |
| Editor configuration | Relevant editor feature |
| Shell configuration | Relevant shell feature |
| Window manager | `modules/desktop/` |
| System service | `modules/services/` |
| Global Nix settings | `modules/system/nix.nix` |
| Locale and timezone defaults | `modules/system/locale.nix` |
| Hardware configuration | Host-specific excluded file |
| Hostname | Host module |
| Host-specific overrides | Host module |
| Per-user program preferences | Home Manager module for that feature |
| System-wide shell aliases | NixOS module for the relevant feature |
| User-specific shell aliases | Home Manager module for the relevant feature |

When uncertain, prefer the feature that conceptually owns the behavior.

Do not create a generic miscellaneous configuration file for unrelated settings.

## 13. Validation

Validate modifications before considering them complete.

At minimum, when the commands are available:

```bash
nix flake show
nix flake check
```

For an affected NixOS host:

```bash
nix build .#nixosConfigurations.laptop.config.system.build.toplevel --no-link
```

Replace `laptop` with the actual host name.

Where applicable, check a specific configuration value using `nix eval`.

### Validation rules

- Do not claim a change builds successfully unless it has actually been built or evaluated successfully.
- Explain validation failures clearly.
- Distinguish evaluation errors from build errors.
- Account for platform differences when checking from another machine.
- Do not activate a configuration unless explicitly asked.
- Do not update `flake.lock` unnecessarily.
- Do not change `system.stateVersion` or `home.stateVersion` merely because a newer release exists.

Preserve existing state versions unless a deliberate migration requires changing them.

## 14. Code style

Follow the existing repository formatting conventions.

Unless the repository establishes different rules:

- Use two-space indentation.
- Prefer clear, descriptive attribute names.
- Keep modules focused.
- Avoid unnecessary comments.
- Document surprising decisions and non-obvious behavior.
- Prefer consistent formatting across related feature modules.
- Keep import lists readable.
- Use `nixfmt` if it is the repository's chosen formatter.

Use nested module functions clearly:

```nix
{ ... }: {
  flake.modules.nixos.example = { pkgs, ... }: {
    environment.systemPackages = [
      pkgs.example
    ];
  };
}
```

Remember that the outer module and inner NixOS/Home Manager modules are evaluated in different module systems.

Do not assume their arguments or `config` values refer to the same configuration.

Use explicit variable names or `let` bindings when that distinction matters.

## 15. AI assistant operating rules

When working in this repository, AI assistants must:

1. **Respect the architecture.** Preserve the Dendritic, feature-oriented design.
2. **Prefer existing conventions.** Examine nearby modules before creating new ones.
3. **Keep changes focused.** Modify only what the requested task requires.
4. **Avoid unsolicited refactoring.** Do not reorganize the repository while implementing unrelated functionality.
5. **Keep related settings together.** Define corresponding NixOS and Home Manager modules in the same feature file when appropriate.
6. **Use explicit host imports.** Never silently activate features across machines.
7. **Avoid speculative complexity.** Do not add profiles, factories, registries, or enable frameworks without approval.
8. **Maintain host independence.** Do not assume settings for one machine should apply to all machines.
9. **Validate when possible.** Report the commands executed and their results.
10. **Explain tradeoffs.** When several solutions are reasonable, prefer the simplest one compatible with this architecture.

### Before proposing architectural changes

Ask whether the proposed change is actually necessary for a configuration supporting only a few machines.

Optimize for:

1. Clarity
2. Maintainability
3. Modularity
4. Reusability
5. Simplicity

Do not optimize for abstraction or scalability at the expense of understanding.

## 16. Quick reference

**When asked to add a feature:**

Create or edit one feature-oriented flake-parts module, export the appropriate typed modules, and explicitly import them into the relevant host and Home Manager user.

**When asked to change a program's settings:**

Modify the existing feature, choosing NixOS or Home Manager according to the setting's scope.

**When asked to configure a new machine:**

Create a host-specific flake-parts module that defines its configuration output and imports the desired features.

**When encountering repeated imports:**

Accept small amounts of repetition. Do not immediately introduce profiles.

**When a file must not be auto-imported:**

Place it in an underscore-prefixed path or otherwise exclude it using the repository's established import-tree rules.

**When unsure where configuration belongs:**

Favor feature-oriented organization, explicit composition, and standard Nix module mechanisms.

---

## Final architectural principle

**Define features once, group related NixOS and Home Manager configuration together, and let each host explicitly choose what it uses.**

Keep the configuration straightforward and easy to understand. Add complexity only when there is a concrete reason for it.
