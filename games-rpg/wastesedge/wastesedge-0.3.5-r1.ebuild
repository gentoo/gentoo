# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 )
inherit eutils python-single-r1

DESCRIPTION="role playing game to showcase the adonthell engine"
HOMEPAGE="http://adonthell.linuxgames.com/"
SRC_URI="https://savannah.nongnu.org/download/adonthell/${PN}-src-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="nls"
RESTRICT="userpriv"

RDEPEND="${PYTHON_DEPS}
	>=games-rpg/adonthell-0.3.5-r2[${PYTHON_USEDEP}]
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

pkg_setup() {
	python-single-r1_pkg_setup
}

src_configure(){
	econf \
		$(use_enable nls) \
		--with-adonthell-binary="/usr/bin/adonthell"
}

src_install(){
	emake DESTDIR="${D}" pixmapdir=/usr/share/pixmaps install
	dodoc AUTHORS ChangeLog NEWS PLAYING README
	make_desktop_entry adonthell-wastesedge "Waste's Edge" wastesedge_32x32
}
