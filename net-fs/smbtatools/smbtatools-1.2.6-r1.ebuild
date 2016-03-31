# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils

DESCRIPTION="Tools for configuration and query of SMB Traffic Analyzer"
HOMEPAGE="https://github.com/hhetter/smbtatools"
SRC_URI="http://morelias.org/smbta/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND="
	dev-db/libdbi
	>=dev-db/sqlite-3.7.0:3
	net-fs/samba
	net-misc/curl
	sys-libs/ncurses:0=
	sys-libs/talloc
	x11-libs/cairo
	x11-libs/pango
	dev-qt/qtgui:4
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"
RDEPEND+="
	net-fs/smbtad
"

DOCS="doc/smbta-guide.html doc/gfx/*.png"
PATCHES=( "${FILESDIR}"/${P}-fix-cmake.patch )

src_configure() {
	local mycmakeargs=(
		-Ddebug=$(usex debug)
		-DLIBSMBCLIENT_LIBRARIES="$(pkg-config --libs smbclient)"
		-DLIBSMBCLIENT_INCLUDE_DIRS="$(pkg-config --variable includedir smbclient)"
	)

	cmake-utils_src_configure
}
