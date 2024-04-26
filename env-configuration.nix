{ config, pkgs, ... }:

# https://teu5us.github.io/nix-lib.html

let
 envVars = builtins.readFile ./secrets/environment;
in
{
  # Environment variables.
  environment.variables = {
    #PATH="$PATH:$HOME/bin";
    TERM = "xterm-256color";
    # PS1 = "\[\033[01;32m\][\u@\h\[\033[01;37m\] \W\[\033[01;32m\]]\$\[\033[00m\] ";
    EDITOR = "vi";
    HISTCONTROL = "ignoredups:erasedups";
    QT_LOGGING_RULES = "*=false";
    FREETYPE_PROPERTIES = "truetype:interpreter-version=38";
  };

  environment.interactiveShellInit = ''
    #alias config='git --git-dir=/home/mdo/.cfg/ --work-tree=/home/mdo'
  '' + envVars;
}

