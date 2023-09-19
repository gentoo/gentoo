# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Self-employed-mode software for 3COM/USR message modems"
HOMEPAGE="https://web.archive.org/web/20031204100644/http://www.hof-berlin.de:80/mepl/"
SRC_URI="http://www.hof-berlin.de/mepl/mepl${PV}.tar.gz"
S="${WORKDIR}/${PN}${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

PATCHES=(
	"${FILESDIR}"/${P}-makefile.patch
	"${FILESDIR}"/${P}-gcc433.patch
)

src_configure() {
	tc-export CC
}

src_install() {
	dobin mepl meplmail
	insinto /etc
	doins mepl.conf
	newman mepl.en mepl.7
}
