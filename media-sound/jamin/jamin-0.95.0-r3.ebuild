# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit autotools

DESCRIPTION="JAMin is the JACK Audio Connection Kit (JACK) Audio Mastering interface"
HOMEPAGE="http://jamin.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="osc"

RDEPEND="
	>=dev-libs/libxml2-2.5
	>=media-plugins/swh-plugins-0.4.6
	>=media-sound/jack-audio-connection-kit-0.80.0
	>=sci-libs/fftw-3.0.1
	>=x11-libs/gtk+-2:2
	media-libs/alsa-lib
	media-libs/ladspa-sdk
	media-libs/libsndfile
	osc? ( >=media-libs/liblo-0.5 )
"
DEPEND="
	${RDEPEND}
"

DOCS=(
	AUTHORS ChangeLog NEWS README TODO
)

PATCHES=(
	"${FILESDIR}"/${P}-multilib-strict.patch
	"${FILESDIR}"/${P}-desktop.patch
)

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	econf \
		$(use_enable osc)
}
