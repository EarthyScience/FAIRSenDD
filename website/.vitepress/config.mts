import { defineConfig } from 'vitepress'
import mathjax3 from 'markdown-it-mathjax3';

const customElements = [
  'mjx-container',
  'mjx-assistive-mml',
  'math',
  'maction',
  'maligngroup',
  'malignmark',
  'menclose',
  'merror',
  'mfenced',
  'mfrac',
  'mi',
  'mlongdiv',
  'mmultiscripts',
  'mn',
  'mo',
  'mover',
  'mpadded',
  'mphantom',
  'mroot',
  'mrow',
  'ms',
  'mscarries',
  'mscarry',
  'mscarries',
  'msgroup',
  'mstack',
  'mlongdiv',
  'msline',
  'mstack',
  'mspace',
  'msqrt',
  'msrow',
  'mstack',
  'mstack',
  'mstyle',
  'msub',
  'msup',
  'msubsup',
  'mtable',
  'mtd',
  'mtext',
  'mtr',
  'munder',
  'munderover',
  'semantics',
  'math',
  'mi',
  'mn',
  'mo',
  'ms',
  'mspace',
  'mtext',
  'menclose',
  'merror',
  'mfenced',
  'mfrac',
  'mpadded',
  'mphantom',
  'mroot',
  'mrow',
  'msqrt',
  'mstyle',
  'mmultiscripts',
  'mover',
  'mprescripts',
  'msub',
  'msubsup',
  'msup',
  'munder',
  'munderover',
  'none',
  'maligngroup',
  'malignmark',
  'mtable',
  'mtd',
  'mtr',
  'mlongdiv',
  'mscarries',
  'mscarry',
  'msgroup',
  'msline',
  'msrow',
  'mstack',
  'maction',
  'semantics',
  'annotation',
  'annotation-xml',
];


// https://vitepress.dev/reference/site-config
export default defineConfig({
  title: "FAIRSenDD",
  srcDir: './docs',
  base: '/FAIRSenDD',
  markdown: {
    config: (md) => {
      md.use(mathjax3);
    },
  },
  vue: {
    template: {
      compilerOptions: {
        isCustomElement: (tag) => customElements.includes(tag),
      },
    },
  },
  vite: {
    server: {
      allowedHosts: [
        'fairsendd.eodchosting.eu',
        'earthyscience.github.io',
      ],
    }
  },
  themeConfig: {
    // https://vitepress.dev/reference/default-theme-config

    nav: [
      { text: 'Home', link: '/' },
      { text: 'Documentation', link: '/overview' },
      { text: 'Imprint', link: 'https://www.bgc-jena.mpg.de/2299/imprint' }
    ],

    sidebar: [
      {
        items: [
          {text: "Overview", link: "overview.md"},
          {text: "Background", link: "background.md"},
          {text: "Julia Library", link: "julia-library.md"},
          {text: "CWL Workflow", link: "cwl-workflow.md"},
          {text: "OGC API - Processes", link: "ogc-api.md"},
        ]
      }
    ],

    socialLinks: [
      { icon: 'github', link: 'https://github.com/EarthyScience/FAIRSenDD' }
    ],

    search: {
      provider: 'local'
    },

    footer: {
      message: `
        <a href="https://www.bgc-jena.mpg.de/en"><img src="logo-mpi-bgc.svg" class = "footer-logo"/></a>
        <a href="https://www.esa.int/About_Us/ESRIN"><img src="ESA_logo.svg" class = "footer-logo"/></a>
        <a href="https://nor-discover.org/"><img src="ESA_NoR_logo.svg" class = "footer-logo"/></a>
        `,
      copyright: `© Copyright ${new Date().getUTCFullYear()}.`
    },
  },
})