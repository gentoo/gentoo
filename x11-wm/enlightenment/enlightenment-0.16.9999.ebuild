# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"
if [[ ${PV} == *9999 ]] ; then
	ESVN_REPO_URI="http://svn.enlightenment.org/svn/e/trunk/E16/e"
	inherit subversion autotools
	SRC_URI=""
	#KEYWORDS=""
	S=${WORKDIR}/e16/e
else
	SRC_URI="mirror://sourceforge/enlightenment/e16-${PV/_/-}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
	S=${WORKDIR}/e16-${PV/_pre?}
fi
inherit eutils

DESCRIPTION="Enlightenment Window Manager (e16)"
HOMEPAGE="http://www.enlightenment.org/"

LICENSE="BSD"
SLOT="0"
IUSE="dbus doc nls pango pulseaudio xcomposite xinerama xrandr"

RDEPEND="pulseaudio? ( media-sound/pulseaudio )
	dbus? ( sys-apps/dbus )
	pango? ( x11-libs/pango )
	=media-libs/freetype-2*
	>=media-libs/imlib2-1.3.0[X]
	x11-libs/libSM
	x11-libs/libICE
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXdamage
	x11-libs/libXxf86vm
	x11-libs/libXft
	xrandr? ( x11-libs/libXrandr )
	x11-libs/libXrender
	x11-misc/xbitmaps
	xinerama? ( x11-libs/libXinerama )
	xcomposite? ( x11-libs/libXcomposite )
	nls? ( virtual/libintl )
	virtual/libiconv"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	x11-proto/xextproto
	x11-proto/xf86vidmodeproto
	xinerama? ( x11-proto/xineramaproto )
	xcomposite? ( x11-proto/compositeproto )
	x11-proto/xproto
	nls? ( sys-devel/gettext )"
PDEPEND="doc? ( app-doc/edox-data )"

src_prepare() {
	if [[ ! -e configure ]] ; then
		eautopoint
		eautoreconf
	fi
}

src_configure() {
	econf \
		$(use_enable nls) \
		$(use_enable dbus) \
		$(use_enable pulseaudio sound-pulse) \
		--disable-sound-esound \
		$(use_enable pango) \
		$(use_enable xinerama) \
		$(use_enable xrandr) \
		$(use_enable xcomposite composite) \
		--disable-docs \
		--enable-zoom
}

src_install() {
	default
	dodoc COMPLIANCE sample-scripts/*
	dohtml docs/e16.html
}
