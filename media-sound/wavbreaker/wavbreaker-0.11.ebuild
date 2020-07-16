# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="wavbreaker/wavmerge GTK+ utility to break or merge WAV files"
HOMEPAGE="http://wavbreaker.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="alsa nls oss pulseaudio"

RDEPEND="
	dev-libs/libxml2:=
	x11-libs/gtk+:2
	alsa? ( media-libs/alsa-lib:= )
	pulseaudio? ( media-sound/pulseaudio:= )"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

PATCHES=(
	"${FILESDIR}"/${PN}-0.10-pkgconfig.patch
	"${FILESDIR}"/${PN}-0.11-QA-desktop-file.patch
)

src_prepare() {
	default
	mv configure.{in,ac} || die
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable nls) \
		$(use_enable alsa) \
		$(use_enable pulseaudio pulse) \
		$(use_enable oss)
}
