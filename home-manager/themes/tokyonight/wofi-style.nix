{ config, pkgs, lib, ... }:

{
  # Wofi Tokyo Night styling
  xdg.configFile."wofi/style.css".text = ''
    /* Tokyo Night colors */
    @define-color highlight #f7768e;
    @define-color base1 rgba(0,0,0,0.2);
    @define-color base2 rgba(0,0,0,0.8);
    @define-color base3 rgba(0,0,0,0.1);

    * {
        font-family: JetBrains Mono Nerd Font;
    }

    window {
        color: #bb9af7;
        position: relative;
        padding: 1px;
    }

    #input {
        margin-bottom: 15px;
        padding: 3px;
        border-radius: 5px;
        border: none;
        outline: none;
        color: #bb9af7;
        background-color: #0a0a0a;
    }

    #inner-box {
    }

    #outer-box {
        margin: 3px;
        padding: 15px;
        background-color: #0a0a0a;
        border-radius: 8px;
    }

    #text {
        padding: 5px;
    }

    #entry:selected {
        color: black;
        background-color: @highlight;
        border: none;
        outline: none;
    }
  '';
}
