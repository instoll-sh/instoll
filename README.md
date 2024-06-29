<!-- markdownlint-disable no-inline-html first-line-h1 -->

[![GitHub Release Date][github-release-date]][github-release-page]
[![GitHub workflow status][github-workflow-status]][github-workflow-runs]
[![GitHub License][github-license]](LICENSE)
![Made with love][made-with-love]
![GitHub Repo stars][github-stars]

<div align="center">
  <!-- <a href="https://github.com/instoll-sh/instoll">
    <img src="images/logo.png" alt="Logo" width="80" height="80">
  </a> -->

<h3 align="center">instoll</h3>

  <p align="center">
    A tool to easily install packages from <b>GitHub</b> that have an <b>install.sh</b> file
    <br />
    <br />
    <a href="https://github.com/instoll-sh/instoll/issues/new?labels=bug&template=bug-report---.md">Report Bug</a>
    ·
    <a href="https://github.com/instoll-sh/instoll/issues/new?labels=enhancement&template=feature-request---.md">Request Feature</a>
  </p>
</div>

<!-- ABOUT THE PROJECT -->
## ℹ️ About The Project

This project is designed to make it easier to install any tools from **GitHub** that have an **install.sh**

### 🤔 Reason for creating this tool

In order to create a **deb**/**snap** package, you need to read a **ton of documentation** and spend a **lot of time** literally packaging a simple script 🥵

But there is another option to install the package using the **installer** (install.sh)

The installer is **much easier** to write, besides, this option is much more **flexible and customizable** ✨

### Why "instOll" ?

`[ɪnˈstɔːl]`

This name comes from the word "**install**" with an **Indian accent**, as in cool YouTube programming guides from Indians 🙃

---

## 📥 Installation

Just run this command:

```bash
curl -fsSL https://raw.githubusercontent.com/instoll-sh/instoll/main/install.sh | bash
```

## 🚀 Usage

### Installing the program

```bash
instoll <username>/<repo>
```

You can also use such a **moniker**:

```bash
instoll <username>.<repo>
```

<!-- markdownlint-disable MD026 -->
### Example of program installation from **GitHub**:

```bash
instoll hikariatama/Hikka
```

This command will download [**install.sh**](https://github.com/hikariatama/Hikka/blob/master/install.sh) from the [**hikariatama/Hikka**](https://github.com/hikariatama/Hikka) repo and execute it

---

You can also use the **URL** of the installer:

```bash
instoll https://useful-tool.com/install.sh
```

An example of installing [**Bun**](https://bun.sh):

```bash
instoll https://bun.sh/install
```

**Aliases** will be added soon for an **even easier** installation 😏:

```bash
instoll bun
```

## 🛣️ Roadmap

- [ ] ⚡ Add the ability to use aliases for an even easier installation, for example `install hikka` or `install dotload`

See the [open issues](https://github.com/instoll-sh/instoll/issues) for a full list of proposed features (and known issues).

## 🤝 Contributing

Contributions are what make the open-source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

You can start developing on [**GitHub Codespaces**][codespaces-link] right away

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/instoll-sh/instoll?quickstart=1)

Or use the usual method on your computer:

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

Please make sure to update tests as appropriate.

Also, please read our [**Code of Conduct**](CODE_OF_CONDUCT.md), and follow it in all your interactions with the project.

## 📝 License

This project is [**MIT**][mit-license-link] licensed.

See [**LICENSE**](LICENSE)

## 📨 Contact

**Telegram:** [**@Okinea**][telegram-link]

## ❤️ Support

This project is completely **free** and **open source**.

If you liked this tool - I would be very grateful if you could support me financially

Here are the details for transfers:

- 🍩 **Donatello**: <https://donatello.to/okineadev>

<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[github-release-date]: https://img.shields.io/github/release-date/instoll-sh/instoll
[github-release-page]: https://github.com/instoll-sh/instoll/releases/latest
[github-workflow-status]: https://github.com/instoll-sh/instoll/actions/workflows/release.yml/badge.svg
[github-workflow-runs]: https://github.com/instoll-sh/instoll/actions/workflows/release.yml
[github-license]: https://img.shields.io/github/license/instoll-sh/instoll
[made-with-love]: https://img.shields.io/badge/made_with-%E2%9D%A4%EF%B8%8F-white
[github-stars]: https://img.shields.io/github/stars/instoll-sh/instoll
[codespaces-link]: https://github.com/features/codespaces
[telegram-link]: https://t.me/okinea
[mit-license-link]: https://opensource.org/license/MIT
