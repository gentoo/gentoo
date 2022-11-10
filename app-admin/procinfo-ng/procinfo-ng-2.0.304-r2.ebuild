# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

DESCRIPTION="Completely rewrite of the old system monitoring app procinfo"
HOMEPAGE="https://sourceforge.net/projects/procinfo-ng/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="|| ( GPL-2 LGPL-2.1 )"
SLOT="0"
KEYWORDS="amd64 ~hppa x86"

RDEPEND="sys-libs/ncurses:="
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-autotools.patch
	"${FILESDIR}"/${P}-man.patch
	"${FILESDIR}"/${P}-wformat-security.patch
)

src_prepare() {
	default

	mv configure.{in,ac} || die
	eautoreconf
}

src_configure() {
	# bug #719790
	append-cxxflags -std=c++03

	default
}
