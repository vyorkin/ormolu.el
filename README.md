# ormolu.el

Format Haskell source code using [ormolu](https://github.com/tweag/ormolu).

# Usage

With [use-package](https://github.com/jwiegley/use-package/):

```elisp
(use-package ormolu
 :hook (haskell-mode . ormolu-format-on-save-mode)
 :config
 (:map haskell-mode-map
   ("C-c r" . ormolu-format-buffer)))
```
