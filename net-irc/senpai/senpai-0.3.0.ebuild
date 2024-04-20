# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="Modern terminal IRC client. NOTICE me :senpai!"
HOMEPAGE="https://sr.ht/~delthas/senpai"
SRC_URI="https://git.sr.ht/~delthas/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://github.com/alfredfo/${PN}-deps/raw/master/${P}-deps.tar.xz"

LICENSE="Apache-2.0 BSD BSD-2 ISC MIT"
SLOT="0"
KEYWORDS="~amd64"

S="${WORKDIR}/${PN}-v${PV}"

BDEPEND="
	app-text/scdoc
"

src_compile() {
	ego build ${GOFLAGS} ./cmd/senpai

	scdoc <doc/senpai.1.scd >doc/senpai.1 || die
	scdoc <doc/senpai.5.scd >doc/senpai.5 || die
}

src_install() {
	dobin senpai

	doman doc/senpai.{1,5}
	einstalldocs
}
