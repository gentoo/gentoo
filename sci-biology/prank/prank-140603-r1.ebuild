# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Probabilistic Alignment Kit"
HOMEPAGE="http://wasabiapp.org/software/prank/"
SRC_URI="http://wasabiapp.org/download/${PN}/${PN}.source.${PV}.tgz"
S="${WORKDIR}/${PN}-msa/src"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

PATCHES=(
	"${FILESDIR}"/${P}-makefile.patch
	"${FILESDIR}"/${P}-fix-c++14.patch
)

src_configure() {
	tc-export CXX
}

src_install() {
	dobin prank
}
