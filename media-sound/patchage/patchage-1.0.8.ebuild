# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson xdg

DESCRIPTION="Modular patch bay for JACK-based audio and MIDI systems"
HOMEPAGE="https://drobilla.net/software/patchage"

if [[ ${PV} == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.com/drobilla/patchage.git"
else
	SRC_URI="https://download.drobilla.net/${P}.tar.xz"
	KEYWORDS="amd64 x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="alsa jack jack-dbus test"
RESTRICT="!test? ( test )"

BDEPEND="
	virtual/pkgconfig
"
RDEPEND="dev-cpp/glibmm:2
	dev-cpp/gtkmm:2.4
	media-libs/ganv
	alsa? ( media-libs/alsa-lib )
	jack? ( virtual/jack )
	jack-dbus? (
		dev-libs/dbus-glib
		sys-apps/dbus
	)"
DEPEND="${RDEPEND}
	dev-libs/boost
	<dev-libs/libfmt-9:="

DOCS=( AUTHORS NEWS README.md )

src_configure() {
	local emesonargs=(
		$(meson_feature alsa)
		$(meson_feature jack)
		$(meson_feature jack-dbus jack_dbus)
		$(meson_feature test tests)
	)
	meson_src_configure
}
