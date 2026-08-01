# Copyright 2019-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson xdg

DESCRIPTION="Wayfire Config Manager"
HOMEPAGE="https://github.com/WayfireWM/wcm"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/WayfireWM/wcm.git"
	SLOT="0/0.12"
else
	COMMIT=14f2e03fc4bfa3a20d10b913461636363e39240c
	SRC_URI="https://github.com/WayfireWM/wcm/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}"/${PN}-${COMMIT}
	KEYWORDS="~amd64"
	SLOT="0/$(ver_cut 1-2)"
fi

LICENSE="MIT"

RESTRICT="test" # no tests

COMMON_DEPEND="
	dev-cpp/atkmm:0
	dev-cpp/glibmm:2
	dev-cpp/gtkmm:3.0[wayland]
	dev-libs/glib:2
	dev-libs/libevdev
	>=dev-libs/libfmt-12:=
	dev-libs/libsigc++:2
	dev-libs/libxml2:=
	dev-libs/wayland
	gui-apps/wf-shell:${SLOT}
	gui-libs/wf-config:${SLOT}
	gui-wm/wayfire:${SLOT}
	x11-libs/gtk+:3
	x11-libs/libxkbcommon
"
RDEPEND="${COMMON_DEPEND}"
DEPEND="
	${COMMON_DEPEND}
	dev-libs/wayland-protocols
"
BDEPEND="
	dev-util/wayland-scanner
	sys-devel/gettext
	virtual/pkgconfig
"

src_configure() {
	local emesonargs=(
		-Dwf_shell=enabled
	)

	meson_src_configure
}
