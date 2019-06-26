# ormolu.el

A formatter for Haskell source code.

# Usage

With [use-package](https://github.com/jwiegley/use-package/) + [quelpa](https://framagit.org/steckerhalter/quelpa):

```elisp
(use-package ormolu
 :quelpa
 (ormolu
  :fetcher github
  :repo "vyorkin/ormolu.el"))
```

## Example config

```elisp
(use-package ormolu
 :quelpa
 (ormolu
  :fetcher github
  :repo "vyorkin/ormolu.el")
 :hook (haskell-mode . ormolu-mode)
 :custom
 (ormolu-reformat-buffer-on-save t)
 :config
 (nmap 'haskell-mode-map
   "C-c r" 'ormolu-format-buffer))
```

# Credits

Mostly inspired by the [hindent](https://github.com/chrisdone/hindent) package.
