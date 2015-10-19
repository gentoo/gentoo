# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools multilib

DESCRIPTION="Fireflies screensaver: Wicked cool eye candy"
HOMEPAGE="https://github.com/mpcomplete/fireflies"
SRC_URI="https://github.com/mpcomplete/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2 icu"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="media-libs/libsdl[X,opengl,video]
	virtual/glu
	virtual/opengl
	x11-libs/libX11"
DEPEND="${RDEPEND}
	sys-devel/autoconf-archive"  # for AX_CXX_BOOL macro

DOCS=( ChangeLog README.md TODO )

src_prepare() {
	eautoreconf
}

src_configure() {
	econf \
		--with-confdir=/usr/share/xscreensaver/config \
		--with-bindir="/usr/$(get_libdir)/misc/xscreensaver"
}

src_install() {
	newbin {,${PN}-}add-xscreensaver

	default
}
