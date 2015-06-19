# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/jack-rack/jack-rack-1.4.8_rc1.ebuild,v 1.7 2014/08/10 21:07:22 slyfox Exp $

EAPI=4
inherit autotools eutils flag-o-matic toolchain-funcs

MY_P=${PN}_${PV/_/\~}
DEB_URI="mirror://debian/pool/main/j/${PN}"

DESCRIPTION="JACK Rack is an effects rack for the JACK low latency audio API"
HOMEPAGE="http://jack-rack.sourceforge.net/"
SRC_URI="${DEB_URI}/${MY_P}.orig.tar.gz ${DEB_URI}/${MY_P}-1.debian.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="alsa gnome lash +xml"

RDEPEND=">=x11-libs/gtk+-2.12:2
	>=media-libs/ladspa-sdk-1.12
	media-sound/jack-audio-connection-kit
	alsa? ( media-libs/alsa-lib )
	lash? ( >=media-sound/lash-0.5 )
	gnome? ( >=gnome-base/libgnomeui-2 )
	virtual/libintl
	xml? ( dev-libs/libxml2
		media-libs/liblrdf )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	sys-devel/gettext"

DOCS=( AUTHORS BUGS ChangeLog NEWS README THANKS TODO WISHLIST )

src_unpack() {
	unpack ${A}
	mv ${PN}-* "${S}"
}

src_prepare() {
	EPATCH_FORCE=yes EPATCH_SUFFIX=patch epatch "${WORKDIR}"/debian/patches

	epatch \
		"${FILESDIR}"/${PN}-1.4.6-noalsa.patch \
		"${FILESDIR}"/${PN}-1.4.7-disable_deprecated.patch \
		"${FILESDIR}"/${P}-noxml.patch \
		"${FILESDIR}"/${P}-underlinking.patch

	sed -i \
		-e '/Categories/s:Application:GTK:' \
		-e '/Icon/s:.png::' \
		${PN}.desktop || die

	eautopoint
	eautoreconf
}

src_configure() {
	# Use lrdf.pc to get -I/usr/include/raptor2 (lrdf.h -> raptor.h)
	use xml && append-cppflags $($(tc-getPKG_CONFIG) --cflags lrdf)

	econf \
		$(use_enable alsa aseq) \
		$(use_enable gnome) \
		$(use_enable lash) \
		$(use_enable xml) \
		$(use_enable xml lrdf)
}
