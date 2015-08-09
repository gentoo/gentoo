# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit nsplugins multilib

MY_P=${P/-plugin/}
S=${WORKDIR}/${MY_P}

DESCRIPTION="The Kaffeine Mozilla starter plugin"
HOMEPAGE="http://kaffeine.sourceforge.net/"
SRC_URI="mirror://sourceforge/kaffeine/${MY_P}.tar.bz2"

SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
LICENSE="GPL-2"
IUSE=""

RDEPEND=">=media-video/kaffeine-0.4.3
	x11-libs/libXaw"
DEPEND="${RDEPEND}"

src_compile() {
	econf \
		--prefix=/usr/$(get_libdir)/${PLUGINS_DIR}
		--libdir=/usr/$(get_libdir)/${PLUGINS_DIR%plugins}

	emake || die
}

src_install() {
	einstall prefix="${D}"/usr/$(get_libdir)/${PLUGINS_DIR%plugins} || die
	dodoc AUTHORS ChangeLog README
}
