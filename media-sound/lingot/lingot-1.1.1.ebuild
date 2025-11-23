# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools xdg

DESCRIPTION="Accurate, easy to use, and highly configurable musical instrument tuner"
HOMEPAGE="https://www.nongnu.org/lingot/"
SRC_URI="https://download.savannah.gnu.org/releases/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa +fftw jack pulseaudio test"
RESTRICT="!test? ( test )"
REQUIRED_USE="test? ( pulseaudio )"

RDEPEND="
	dev-libs/glib:2
	dev-libs/json-c:=
	x11-libs/cairo
	x11-libs/gtk+:3
	alsa? ( media-libs/alsa-lib )
	fftw? ( sci-libs/fftw:3.0= )
	jack? ( virtual/jack )
	pulseaudio? ( media-libs/libpulse )
"
DEPEND="${RDEPEND}
	test? ( dev-util/cunit )
"
BDEPEND="
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig
"

PATCHES=( "${FILESDIR}"/${P}-desktop-icon.patch )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myemakeargs=(
		$(use_with alsa)
		$(use_with fftw)
		$(use_with jack)
		$(use_with pulseaudio)
		$(use_with test cunit)
	)

	econf "${myemakeargs[@]}"
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
