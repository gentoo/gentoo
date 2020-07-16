# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="A Linux interactivity benchmark"
HOMEPAGE="https://github.com/ckolivas/interbench/"
SRC_URI="https://github.com/ckolivas/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="amd64 x86"
LICENSE="GPL-2+"
SLOT="0"

PATCHES=( "${FILESDIR}/${P}-makefile.patch" )

DOCS=(
	"readme"
	"readme.interactivity"
)

src_prepare() {
	default

	tc-export CC
}

src_install() {
	dobin interbench
	doman interbench.8

	einstalldocs
}
