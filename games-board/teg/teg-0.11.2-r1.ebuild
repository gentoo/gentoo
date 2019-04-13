# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnome2

DESCRIPTION="Gnome Risk Clone"
HOMEPAGE="https://github.com/wfx/teg"
SRC_URI="https://github.com/wfx/teg/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE="+client debug ggz nls robot server"

RDEPEND="dev-libs/glib:2
	gnome-base/libgnomeui
	gnome-base/libgnome
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	app-text/tidy-html5
	nls? ( sys-devel/gettext )"

src_configure() {
	econf \
		$(use_enable client) \
		$(use_enable debug) \
		$(use_enable ggz) \
		$(use_enable robot) \
		$(use_enable server)
}
