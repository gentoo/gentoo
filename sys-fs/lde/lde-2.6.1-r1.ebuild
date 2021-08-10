# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="ext2fs and minix disk editor for linux"
HOMEPAGE="http://lde.sourceforge.net/"
SRC_URI="mirror://sourceforge/lde/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="sys-libs/ncurses:0="
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	virtual/yacc
"

S="${WORKDIR}/${PN}"

PATCHES=(
	"${FILESDIR}/${P}-no-shadowing.patch"
	"${FILESDIR}/${P}-fno-common.patch"
	"${FILESDIR}/${P}-tinfo.patch"
	"${FILESDIR}/${P}-respect-ar.patch"
)

DOCS=( WARNING README TODO COPYING )

RESTRICT="test"

src_prepare() {
	default

	cd macros || die
	mv configure.{in,ac} || die
	eautoreconf
}

src_install() {
	dosbin "${PN}"
	newman "doc/${PN}.man" "${PN}.8"
	einstalldocs
}
