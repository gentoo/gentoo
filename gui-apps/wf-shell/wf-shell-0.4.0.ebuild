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
IUSE="+pulseaudio debug"

DEPEND="
	dev-cpp/gtkmm:3.0=[wayland]
	dev-libs/gobject-introspection
	~gui-wm/wayfire-${PV}
	>=gui-libs/gtk-layer-shell-0.1
	pulseaudio? ( media-sound/pulseaudio )
"

RDEPEND="${DEPEND}"

BDEPEND="
	${DEPEND}
	dev-libs/wayland-protocols
	virtual/pkgconfig
"

src_compile () {
	local emesonargs=(
		"$(meson_feature pulseaudio pulse)"
	)
	if use debug; then
		emesonargs+=(
			"-Db_sanitize=address,undefined"
		)
	fi
	meson_src_compile
}
