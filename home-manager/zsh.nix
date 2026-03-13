{ config, pkgs, lib, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;

    shellAliases = {
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      "....." = "cd ../../../..";
      "......" = "cd ../../../../..";
      vim = "nvim";
      vi = "nvim";
      ls = "eza";
      cat = "bat";
      git = "LANG=en_US git";
    };

    initContent = ''
      parse_git_branch() {
          git_status="$(git status 2> /dev/null)"
          pattern="On branch ([^[:space:]]*)"
          if [[ ! ''${git_status} =~ "(working (tree|directory) clean)" ]]; then
              state="*"
          fi
          if [[ ''${git_status} =~ ''${pattern} ]]; then
            branch=''${match[1]}
            branch_cut=''${branch:0:35}
            if (( ''${#branch} > ''${#branch_cut} )); then
                echo "[''${branch_cut}…''${state}]"
            else
                echo "[''${branch}''${state}]"
            fi
          fi
      }

      setopt PROMPT_SUBST
      PROMPT='%{%F{blue}%}%9c%{%F{green}%} $(parse_git_branch)%{%F{none}%}$ '
    '';
  };
}
