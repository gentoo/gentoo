# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils multilib nsplugins

MY_P=${P/-plugin/}

DESCRIPTION="The Kaffeine Mozilla starter plugin"
HOMEPAGE="http://kaffeine.sourceforge.net/"
SRC_URI="mirror://sourceforge/kaffeine/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXaw
	x11-libs/libXt"
RDEPEND="${DEPEND}
	media-video/kaffeine"

S=${WORKDIR}/${MY_P}

src_install() {
	emake prefix="${D}"/usr/$(get_libdir)/${PLUGINS_DIR%plugins} install
	dodoc AUTHORS ChangeLog README
	prune_libtool_files --modules
}
