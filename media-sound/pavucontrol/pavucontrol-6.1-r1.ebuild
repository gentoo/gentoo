# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="Pulseaudio Volume Control, GTK based mixer for Pulseaudio"
HOMEPAGE="https://freedesktop.org/software/pulseaudio/pavucontrol/"
SRC_URI="https://freedesktop.org/software/pulseaudio/${PN}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm ~arm64 ~hppa ~loong ppc ppc64 ~riscv ~sparc x86"

IUSE="sound"

RDEPEND="
	dev-cpp/gtkmm:4.0
	dev-libs/json-glib
	dev-libs/libsigc++:3
	>=media-libs/libpulse-15.0[glib]
	virtual/freedesktop-icon-theme
	sound? ( media-libs/libcanberra )
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	sys-devel/gettext
"

PATCHES=(
	"${FILESDIR}/pavucontrol-6.1-libcanberra-automagic.patch"
)

src_prepare() {
	default

	# Follow Gentoo FHS with docdir
	sed -i -e "/^docdir/ { s/${PN}/${PF}/ }" meson.build || die
}

src_configure() {
	local emesonargs=(
		-Dlynx=false
		$(meson_feature sound audio-feedback)
	)

	meson_src_configure
}
