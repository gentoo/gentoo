# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Synthesizer keyboard emulation package: Moog, Hammond and others"
HOMEPAGE="https://sourceforge.net/projects/bristol"
SRC_URI="mirror://sourceforge/bristol/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa oss static-libs"
# osc : configure option but no code it seems...
# jack: fails to build if disabled
# pulseaudio: not fully supported

BDEPEND="
	virtual/pkgconfig
"
RDEPEND="
	virtual/jack
	x11-libs/libX11
	alsa? ( >=media-libs/alsa-lib-1.0.0 )
"
# osc? ( >=media-libs/liblo-0.22 )
DEPEND="${RDEPEND}
	x11-base/xorg-proto
"

DOCS=( AUTHORS ChangeLog HOWTO NEWS README )

PATCHES=(
	"${FILESDIR}"/${P}-cflags.patch
	"${FILESDIR}"/${P}-implicit-dec.patch
	"${FILESDIR}"/${P}-dontcompress.patch
	"${FILESDIR}"/${P}-rm_alsa-iatomic.h.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--disable-version-check \
		$(use_enable alsa) \
		$(use_enable oss) \
		$(use_enable static-libs static)
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
