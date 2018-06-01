# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
if [[ ${PV} == *9999 ]] ; then
	ESVN_REPO_URI="https://svn.enlightenment.org/svn/e/trunk/E16/e"
	inherit subversion autotools
	SRC_URI=""
	#KEYWORDS=""
	S=${WORKDIR}/e16/e
else
	SRC_URI="mirror://sourceforge/enlightenment/e16-${PV/_/-}.tar.gz"
	KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sh sparc x86"
	S=${WORKDIR}/e16-${PV/_pre?}
fi
inherit eutils

DESCRIPTION="Enlightenment Window Manager (e16)"
HOMEPAGE="https://www.enlightenment.org/"

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
	x11-base/xorg-proto
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
		$(use_enable pulseaudio sound pulse) \
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
