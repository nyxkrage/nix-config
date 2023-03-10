{ config, pkgs, lib, ... }: {
  home = {
    sessionPath = [ "${config.xdg.configHome}/emacs/bin" ];
    sessionVariables = {
      DOOMDIR = "${config.xdg.configHome}/doom";
      DOOMLOCALDIR = "${config.xdg.configHome}/doom-local";
      DOOMPROFILELOADFILE = "${config.xdg.configHome}/doom-local/profiles.el";
    };
  };
  systemd.user.sessionVariables = config.home.sessionVariables;

  xdg.configFile = {
    "doom" = {
      source = ./doom;
      onChange = "${pkgs.writeShellScript "doom-change" ''
          export DOOMDIR="${config.home.sessionVariables.DOOMDIR}"
          export DOOMLOCALDIR="${config.home.sessionVariables.DOOMLOCALDIR}"
          export PATH="${lib.makeBinPath [ pkgs.git ]}:$PATH"
          export EMACS="${toString config.home.path}/bin/emacs"
          if [ ! -d "$DOOMLOCALDIR" ]; then
            ${config.xdg.configHome}/emacs/bin/doom install
          else
            ${config.xdg.configHome}/emacs/bin/doom sync -u -e
          fi
      ''}";
    };
    "emacs" = {
      source = pkgs.fetchgit {
        url = "https://github.com/doomemacs/doomemacs";
        rev = "e96624926d724aff98e862221422cd7124a99c19";
        sha256 = "sha256-C+mQGq/HBDgRkqdwYE/LB3wQd3oIbTQfzldtuhmKVeU=";
      };
      onChange = "${pkgs.writeShellScript "doom-change" ''
          export DOOMDIR="${config.home.sessionVariables.DOOMDIR}"
          export DOOMLOCALDIR="${config.home.sessionVariables.DOOMLOCALDIR}"
          export PATH="${lib.makeBinPath [ pkgs.git ]}:$PATH"
          export EMACS="${toString config.home.path}/bin/emacs"
          if [ ! -d "$DOOMLOCALDIR" ]; then
            ${config.xdg.configHome}/emacs/bin/doom install
          else
            ${config.xdg.configHome}/emacs/bin/doom sync -u -e
          fi
        ''}";
    };
  };
}
