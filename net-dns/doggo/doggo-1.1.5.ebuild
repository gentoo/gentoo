# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module shell-completion

DESCRIPTION="Command-line DNS Client for Humans"
HOMEPAGE="https://github.com/mr-karan/doggo"

SRC_URI="https://github.com/mr-karan/doggo/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/gentoo-golang-dist/doggo/releases/download/v${PV}/${P}-vendor.tar.xz
"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64"

src_compile() {
	emake build-cli VERSION=${PV}
}

src_install() {
	newbin bin/${PN}.bin ${PN}

	local comp
	for comp in bash fish zsh; do
		bin/${PN}.bin completions $comp > "${WORKDIR}"/${PN}.$comp || die
	done

	newbashcomp "${WORKDIR}"/${PN}.bash ${PN}
	newfishcomp "${WORKDIR}"/${PN}.fish ${PN}.fish
	newzshcomp "${WORKDIR}"/${PN}.zsh _${PN}
}
