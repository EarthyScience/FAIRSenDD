import { defineConfig } from 'vitepress'

// https://vitepress.dev/reference/site-config
export default defineConfig({
  title: "FAIRSenDD",
  themeConfig: {
    // https://vitepress.dev/reference/default-theme-config

    nav: [
      { text: 'Home', link: '/' },
      { text: 'Overview', link: '/overview' },
      { text: 'Imprint', link: 'https://www.bgc-jena.mpg.de/2299/imprint' }
    ],

    socialLinks: [
      { icon: 'github', link: 'https://github.com/EarthyScience/FAIRSenDD' }
    ],

    footer: {
      message: `
        <a href="https://www.bgc-jena.mpg.de/en"><img src="assets/logo-mpi-bgc.svg" class = "footer-logo"/></a>
        <a href="https://www.esa.int/About_Us/ESRIN"><img src="assets/ESA_logo.svg" class = "footer-logo"/></a>
        <a href="https://nor-discover.org/"><img src="assets/ESA_NoR_logo.svg" class = "footer-logo"/></a>
        `,
      copyright: `© Copyright ${new Date().getUTCFullYear()}.`
    }
  }
})
