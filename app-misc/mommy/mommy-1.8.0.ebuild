# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Your very own script that encourages you and gives you compliments"
HOMEPAGE="https://github.com/fwdekker/mommy"
SRC_URI="https://github.com/fwdekker/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P}"

LICENSE="Unlicense"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="bash-completion fish-completion zsh-completion"

src_compile() {
	emake build
}

src_install() {
	emake \
		prefix="${D}/usr" \
		bin_prefix="${D}/usr/bin/" \
		man_prefix="${D}/usr/share/man/" \
		bash_prefix="${D}/usr/share/bash-completion/completions/" \
		fish_prefix="${D}/usr/share/fish/vendor_completions.d/" \
		zsh_prefix="${D}/usr/share/zsh/site-functions/" \
		install
	dodoc README.md CHANGELOG.md
}
