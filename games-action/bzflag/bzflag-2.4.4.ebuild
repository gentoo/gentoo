# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils flag-o-matic games

DESCRIPTION="3D tank combat simulator game"
HOMEPAGE="http://www.bzflag.org/"
SRC_URI="https://download.bzflag.org/bzflag/source/${PV}/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~ppc ~x86"
IUSE="dedicated upnp"

UIDEPEND=""
DEPEND=">=net-misc/curl-7.15.0
	sys-libs/ncurses:0
	net-dns/c-ares
	sys-libs/zlib
	upnp? ( net-libs/miniupnpc )
	!dedicated? (
		virtual/opengl
		virtual/glu
		media-libs/libsdl[sound,joystick,video] )"
RDEPEND=${DEPEND}

src_prepare() {
	epatch "${FILESDIR}"/${P}-configure.patch
	eautoreconf
}

src_configure() {
	local myconf

	if use dedicated ; then
		ewarn
		ewarn "You are building a server-only copy of BZFlag"
		ewarn
		myconf="--disable-client --without-SDL"
	fi
	egamesconf \
		$(use_enable upnp UPnP) \
		${myconf}
}

src_install() {
	DOCS="AUTHORS ChangeLog DEVINFO PORTING README README.Linux" \
		default

	if ! use dedicated ; then
		newicon data/bzflag-48x48.png ${PN}.png
		make_desktop_entry ${PN} "BZFlag"
	fi

	prune_libtool_files --modules
	prepgamesdirs
}
