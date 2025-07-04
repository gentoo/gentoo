# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop flag-o-matic toolchain-funcs xdg

MY_P="${PN}-v${PV}"
DESCRIPTION="Teletext viewer for X11"
HOMEPAGE="https://gitlab.com/alevt/alevt"
SRC_URI="https://gitlab.com/${PN}/${PN}/-/archive/v${PV}/${MY_P}.tar.bz2
	-> ${P}.tar.bz2"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"

RDEPEND="
	x11-libs/libX11
	media-libs/libpng:=
"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-respectflags.patch
	"${FILESDIR}"/${PN}-1.8.2-musl.patch
)

src_configure() {
	# -std-gnu17: bug #945281
	append-cflags -fno-strict-aliasing -std=gnu17
	tc-export BUILD_CC CC
}

src_install() {
	# The upstream Makefile has the 'install' rule under a comment
	# "anything below this line is just for me!", so avoid it.
	dobin alevt alevt-cap alevt-date
	doman alevt.1x alevt-date.1 alevt-cap.1
	einstalldocs

	newicon -s 16 contrib/mini-alevt.xpm alevt.xpm
	newicon -s 48 contrib/icon48x48.xpm alevt.xpm
	make_desktop_entry alevt "AleVT" alevt
}
