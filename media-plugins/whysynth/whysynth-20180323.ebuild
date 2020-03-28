# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools
DESCRIPTION="A software synthesizer plugin for the DSSI Soft Synth Interface"
HOMEPAGE="http://smbolton.com/whysynth.html https://github.com/smbolton/whysynth"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
LICENSE="GPL-2"
WHYSYNTH_COMMIT="32e4bc73baa554bb1844b3165e657911f43f3568"
SRC_URI="https://github.com/smbolton/${PN}/archive/${WHYSYNTH_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${WHYSYNTH_COMMIT}"
RDEPEND="media-libs/dssi
	media-libs/liblo
	sci-libs/fftw:3.0
	x11-libs/gtk+:2
	media-libs/ladspa-sdk
	media-libs/alsa-lib"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	./autogen.sh
	default
	WANT_AUTOMAKE="1.7" eautoreconf
}
