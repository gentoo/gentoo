# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils multilib-minimal

DESCRIPTION="MIDI to WAVE converter library"
HOMEPAGE="http://libtimidity.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 hppa ppc ppc64 sparc x86"
IUSE="ao debug"

RDEPEND="ao? ( >=media-libs/libao-1.1.0-r2[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

RESTRICT="test"
DOCS="AUTHORS ChangeLog CHANGES NEWS TODO README*"

src_prepare() {
	epatch "${FILESDIR}"/${P}-newlen-overflow.patch \
		"${FILESDIR}"/${P}-automagic.patch
	eautoreconf
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf \
		--disable-static \
		$(use_enable ao) \
		$(use_enable debug)
}
