# ormolu.el

Format Haskell source code using [ormolu](https://github.com/tweag/ormolu).  Requires [reformatter.el](https://github.com/purcell/reformatter.el).

# Usage

With [use-package](https://github.com/jwiegley/use-package/):

```elisp
(use-package ormolu
 :hook (haskell-mode . ormolu-format-on-save-mode)
 :bind
 (:map haskell-mode-map
   ("C-c r" . ormolu-format-buffer)))
```

Without:

```elisp
(push "~/.elib/contrib/reformatter.el" load-path)
(push "~/.elib/contrib/ormolu.el" load-path)
(load-library "ormolu")
(add-hook 'haskell-mode-hook 'ormolu-format-on-save-mode)
```

## Additional configuration

The package can be configured via the usual `customize-group RET ormolu` mechanism. For example, to enable the `TypeApplications` extension by default, you can put `("--ghc-opt" "-XTypeApplications")` under the "Ormolu Extra Args" option (`ormolu-extra-args` elisp var).
