# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="A compiz like 3D wayland compositor"
HOMEPAGE="https://github.com/WayfireWM/wf-shell"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/WayfireWM/${PN}.git"
else
	SRC_URI="https://github.com/WayfireWM/${PN}/releases/download/${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm64 ~x86"
fi

LICENSE="MIT"
SLOT="0"
IUSE="+pulseaudio"

DEPEND="
	dev-cpp/gtkmm:3.0=[wayland]
	dev-libs/gobject-introspection
	>=gui-libs/gtk-layer-shell-0.1
	>=gui-wm/wayfire-${PV}
	pulseaudio? ( media-sound/pulseaudio )
"

RDEPEND="${DEPEND}"

BDEPEND="
	dev-libs/wayland-protocols
	virtual/pkgconfig
"

src_configure () {
	local emesonargs=(
		"$(meson_feature pulseaudio pulse)"
	)
	meson_src_configure
}
