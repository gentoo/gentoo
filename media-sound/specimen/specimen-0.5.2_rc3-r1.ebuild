# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/specimen/specimen-0.5.2_rc3-r1.ebuild,v 1.1 2015/02/20 15:09:07 yngwin Exp $

EAPI=5
inherit autotools eutils

MY_P=${P/_/-}

DESCRIPTION="A Midi Controllable Audio Sampler"
HOMEPAGE="http://zhevny.com/specimen"
SRC_URI="http://zhevny.com/${PN}/files/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc sparc x86"
IUSE="lash"

RDEPEND=">=media-sound/jack-audio-connection-kit-0.109.2
	>=media-libs/alsa-lib-0.9
	media-libs/libsamplerate
	media-libs/libsndfile
	>=media-libs/phat-0.4
	dev-libs/libxml2:2
	x11-libs/gtk+:2
	gnome-base/libgnomecanvas
	lash? ( media-sound/lash )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}"/${MY_P}

src_prepare() {
	epatch "${FILESDIR}/${P}-jackmidi.patch" \
		"${FILESDIR}/${P}-underlinking.patch"
	eautoreconf
}

src_configure() {
	econf $(use_enable lash)
}

src_install() {
	default
	dodoc AUTHORS BUGS ChangeLog NEWS PROFILE \
		README ROADMAP TODO STYLE TODO WISHLIST
	doicon pixmaps/${PN}.png
	make_desktop_entry ${PN} Specimen ${PN}
}
