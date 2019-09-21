# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Accurate, easy to use, and highly configurable musical instrument tuner"
HOMEPAGE="https://www.nongnu.org/lingot/"
SRC_URI="https://download.savannah.gnu.org/releases/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa +fftw jack pulseaudio"

RDEPEND="
	dev-libs/glib:2
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3
	alsa? ( media-libs/alsa-lib )
	fftw? ( sci-libs/fftw:3.0= )
	jack? ( virtual/jack )
	pulseaudio? ( media-sound/pulseaudio )
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig
"

PATCHES=( "${FILESDIR}"/${P}-configure.patch )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myemakeargs=(
		$(use_enable alsa)
		$(use_enable fftw libfftw)
		$(use_enable jack)
		$(use_enable pulseaudio)
	)

	econf "${myemakeargs[@]}"
}

src_install() {
	emake DESTDIR="${D}" lingotdocdir="/usr/share/doc/${PF}" install
}
