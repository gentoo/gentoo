# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit cmake-utils

DESCRIPTION="Tools for configuration and query of SMB Traffic Analyzer"
HOMEPAGE="https://github.com/hhetter/smbtatools"
SRC_URI="http://morelias.org/smbta/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="
	dev-db/libdbi
	>=dev-db/sqlite-3.7.0:3
	net-fs/samba
	net-misc/curl
	sys-libs/ncurses
	sys-libs/talloc
	x11-libs/cairo
	x11-libs/pango
	dev-qt/qtgui:4

"
RDEPEND="${DEPEND}
	net-fs/smbtad
"

DOCS="doc/smbta-guide.html doc/gfx/*.png"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use debug)
	)

	cmake-utils_src_configure
}
