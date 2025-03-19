# vitepress-quarto-docker: Reproducible polyglot documentation

[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/danlooo/vitepress-quarto-docker/HEAD)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://danlooo.github.io/vitepress-quarto-docker)

Writing static websites containing code notebooks in various programming languages.

## Motivation

- The vast majority of code notebooks are not reproducible
- Facilitate FAIR principles: multiple programming languages (interoperable) with reproducible code (reuse)

## Get Started

1. Clone the repository:

```{bash}
git clone https://github.com/danlooo/vitepress-quarto-docker
cd vitepress-quarto-docker
```

2. Update code, e.g. add quarto files to the docs directory

3. Deploy locally:

```{bash}
npm install
npm run docs:dev
```

4. Setup GitHub: Set source to GitHub Actions in Pages repo settings

5. pushing changes to GitHuB will automatically render and deploy all quarto websites at https://danlooo.github.io/vitepress-quarto-docker
