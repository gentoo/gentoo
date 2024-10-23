# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Pulseaudio Volume Control, GTK based mixer for Pulseaudio"
HOMEPAGE="https://freedesktop.org/software/pulseaudio/pavucontrol/"
SRC_URI="https://freedesktop.org/software/pulseaudio/${PN}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm ~arm64 ~hppa ~loong ppc ~ppc64 ~riscv ~sparc x86"
IUSE="nls X"

inherit autotools

PATCHES=(
	"${FILESDIR}/${PN}-5.0-make-libcanberra-optional.patch"
)

RDEPEND="
	dev-libs/json-glib
	X? (
		>=dev-cpp/gtkmm-3.22:3.0[X]
		|| (
			media-libs/libcanberra-gtk3
			>=media-libs/libcanberra-0.16[gtk3(-)]
		)
	)
	!X? ( >=dev-cpp/gtkmm-3.22:3.0 )
	>=dev-libs/libsigc++-2.2:2
	>=media-libs/libpulse-15.0[glib]
	virtual/freedesktop-icon-theme
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	nls? (
		dev-util/intltool
		sys-devel/gettext
	)
"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--disable-lynx
		$(use_enable nls)
	)
	econf "${myeconfargs[@]}"
}
