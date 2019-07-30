# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="OffiX' Drag'n'drop library"
HOMEPAGE="http://leb.net/offix"
SRC_URI="http://leb.net/offix/${PN}.${PV}.tgz"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm64 ~hppa ~ia64 ppc ppc64 sparc x86"

RDEPEND="x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXaw
	x11-libs/libXmu
	x11-libs/libXt"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

PATCHES=(
	"${FILESDIR}"/${P}-gentoo.diff
	"${FILESDIR}"/Makefile-fix.patch
)

S="${WORKDIR}/DND/DNDlib"

src_configure() {
	tc-export CC CXX RANLIB AR
	econf --with-x
}

src_install () {
	emake DESTDIR="${D}" install
}
