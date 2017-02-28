# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit vcs-snapshot

DESCRIPTION="Graphical tool to show free disk space like df"
HOMEPAGE="https://gitlab.com/mazes_80/gtkdiskfree"
SRC_URI="https://gitlab.com/mazes_80/${PN}/repository/archive.tar.bz2?ref=${PV} -> ${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="gtk2"

RDEPEND="
	gtk2? ( x11-libs/gtk+:2 )
	!gtk2? ( x11-libs/gtk+:3 )
"
DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/pkgconfig
"

src_configure() {
	econf $(use_with gtk2)
}
