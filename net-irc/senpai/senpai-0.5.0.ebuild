# Copyright 2023-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module xdg

DESCRIPTION="Modern terminal IRC client. NOTICE me :senpai!"
HOMEPAGE="https://sr.ht/~delthas/senpai/"
SRC_URI="https://git.sr.ht/~delthas/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://github.com/gentoo-golang-dist/senpai/releases/download/v${PV}/${P}-deps.tar.xz"

S="${WORKDIR}/${PN}-v${PV}"

LICENSE="Apache-2.0 BSD BSD-2 ISC MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

BDEPEND="
	app-text/scdoc
	sys-apps/which
"

src_compile() {
	emake -j1 VERSION="v${PV}"
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" install
	einstalldocs
}
