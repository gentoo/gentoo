# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop flag-o-matic toolchain-funcs

MY_P="${PN}-v${PV}"
DESCRIPTION="Teletext viewer for X11"
HOMEPAGE="https://gitlab.com/alevt/alevt"
SRC_URI="https://gitlab.com/${PN}/${PN}/-/archive/v${PV}/${MY_P}.tar.bz2
	-> ${P}.tar.bz2"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
RESTRICT="strip"

RDEPEND="
	x11-libs/libX11
	media-libs/libpng:="
DEPEND="${RDEPEND}
	x11-base/xorg-proto"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-respectflags.patch
	"${FILESDIR}"/${PN}-1.6.2-libpng15.patch
)

src_configure() {
	append-cflags -fno-strict-aliasing
	tc-export BUILD_CC CC
}

src_install() {
	dobin alevt alevt-cap alevt-date
	doman alevt.1x alevt-date.1 alevt-cap.1
	einstalldocs

	newicon -s 16 contrib/mini-alevt.xpm alevt.xpm
	newicon -s 48 contrib/icon48x48.xpm alevt.xpm
	make_desktop_entry alevt "AleVT" alevt
}
