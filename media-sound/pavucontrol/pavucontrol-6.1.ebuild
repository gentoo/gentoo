# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Pulseaudio Volume Control, GTK based mixer for Pulseaudio"
HOMEPAGE="https://freedesktop.org/software/pulseaudio/pavucontrol/"
SRC_URI="https://freedesktop.org/software/pulseaudio/${PN}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~sparc x86"
IUSE="X"

inherit meson

RDEPEND="
	dev-libs/json-glib
	dev-cpp/gtkmm:4.0
	X? ( media-libs/libcanberra-gtk3 )
	dev-libs/libsigc++:3
	>=media-libs/libpulse-15.0[glib]
	virtual/freedesktop-icon-theme
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	sys-devel/gettext
"

PATCHES=(
	"${FILESDIR}/pavucontrol-6.1-docdir.patch"
)

src_configure() {
	local emesonargs=(
		-Dlynx=false
	)

	meson_src_configure
}
