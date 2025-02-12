Also see the blog post: [My NixOS
configuration](https://photonsphere.org/post/2020-02-19-nixos-configuration/).

Flaked up; useful commands:

``` {.bash org-language="sh"}
alias swi='( cd /etc/nixos; nixos-rebuild --flake .#sapientia switch ) && ~/bin/nixos-checkreboot.sh ; date'
alias swi-dry-activate='( cd /etc/nixos; nixos-rebuild --flake .#sapientia dry-activate )'
alias swi-dry-build='( cd /etc/nixos; nixos-rebuild --flake .#sapientia dry-build )'
alias upg='( cd /etc/nixos; nix flake update) ; date'
```
