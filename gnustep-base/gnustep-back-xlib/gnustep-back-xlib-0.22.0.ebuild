# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnustep-base/gnustep-back-xlib/gnustep-back-xlib-0.22.0.ebuild,v 1.6 2012/12/20 13:09:06 ago Exp $

EAPI=4
inherit gnustep-base

DESCRIPTION="Default X11 back-end component for the GNUstep GUI Library"
HOMEPAGE="http://www.gnustep.org"
SRC_URI="ftp://ftp.gnustep.org/pub/gnustep/core/gnustep-back-${PV}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="opengl xim"

RDEPEND="${GNUSTEP_CORE_DEPEND}
	=gnustep-base/gnustep-gui-${PV%.*}*
	opengl? ( virtual/opengl virtual/glu )
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXi
	x11-libs/libXmu
	x11-libs/libXt
	x11-libs/libXft
	x11-libs/libXrender
	>=media-libs/freetype-2.1.9

	!gnustep-base/gnustep-back-art
	!gnustep-base/gnustep-back-cairo"
DEPEND="${RDEPEND}"

S=${WORKDIR}/gnustep-back-${PV}

src_configure() {
	egnustep_env

	myconf="$(use_enable opengl glx)"
	myconf="$myconf $(use_enable xim)"
	myconf="$myconf --enable-server=x11"
	myconf="$myconf --enable-graphics=xlib"

	econf $myconf
}
