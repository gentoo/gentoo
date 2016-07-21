# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2
inherit eutils

DESCRIPTION="JAMin is the JACK Audio Connection Kit (JACK) Audio Mastering interface"
HOMEPAGE="http://jamin.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="osc"

RDEPEND=">=media-sound/jack-audio-connection-kit-0.80.0
	>=media-plugins/swh-plugins-0.4.6
	media-libs/ladspa-sdk
	>=sci-libs/fftw-3.0.1
	media-libs/libsndfile
	media-libs/alsa-lib
	>=dev-libs/libxml2-2.5
	>=x11-libs/gtk+-2:2
	osc? ( >=media-libs/liblo-0.5 )"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${P}-multilib-strict.patch"
}

src_configure() {
	econf \
		$(use_enable osc)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog NEWS README TODO
}
