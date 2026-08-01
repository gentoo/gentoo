# Copyright 2019-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson xdg

DESCRIPTION="Compiz like 3D wayland compositor"
HOMEPAGE="https://github.com/WayfireWM/wf-shell"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/WayfireWM/wf-shell.git"
	SLOT="0/0.12"
else
	COMMIT=77038bdf8a05005ff510e7e1ba3ac2054cc304ce
	WF_JSON_COMMIT=70039e13cdeaebd8ec498ed30bf5ab91c2e313ec
	GVC_COMMIT=5f9768a2eac29c1ed56f1fbb449a77a3523683b6

	SRC_URI="
		https://github.com/WayfireWM/wf-shell/archive/${COMMIT}.tar.gz -> ${P}.tar.gz
		https://github.com/WayfireWM/wf-json/archive/${WF_JSON_COMMIT}.tar.gz -> ${PN}-wf-json-${PV}.tar.gz
		pulseaudio? (
			https://github.com/GNOME/libgnome-volume-control/archive/${GVC_COMMIT}.tar.gz -> ${PN}-gnome-volume-control.tar.gz
		)
	"
	S="${WORKDIR}"/${PN}-${COMMIT}
	KEYWORDS="~amd64"
	SLOT="0/$(ver_cut 1-2)"
fi

LICENSE="MIT"
IUSE="ddcutil pipewire +pulseaudio"

# no tests
RESTRICT="test"

DEPEND="
	dev-cpp/cairomm:1.16
	dev-cpp/glibmm:2.68
	dev-cpp/gtkmm:4.0
	dev-libs/glib:2
	>=dev-libs/gobject-introspection-1.82.0-r2
	dev-libs/libsigc++:3
	dev-libs/libdbusmenu[gtk3]
	>=gui-libs/gtk4-layer-shell-1.3.0[introspection]
	dev-libs/openssl:=
	dev-libs/wayland
	dev-libs/yyjson
	gui-libs/gtk:4[wayland]
	>=gui-libs/wf-config-0.7.0:=
	gui-wm/wayfire
	media-libs/libepoxy
	media-libs/mesa[opengl]
	sys-libs/pam
	x11-libs/libdrm
	x11-libs/libxkbcommon
	ddcutil? (
		app-misc/ddcutil:=
	)
	pipewire? (
		media-video/pipewire:=
		media-video/wireplumber:=
	)
	pulseaudio? (
		media-libs/alsa-lib
		media-libs/libpulse
	)
"
RDEPEND="${DEPEND}
	gui-apps/wayland-logout
"
BDEPEND="
	dev-libs/wayland-protocols
	dev-util/wayland-scanner
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.11-add-missing-include.patch
)

src_prepare() {
	default

	if [[ $PV != *9999* ]]; then
		# wf-json is bundled as a subproject
		# no need to unbundle it, it's a static library containing a wrapper to yyjson
		rmdir subprojects/wf-json || die
		mv "${WORKDIR}"/wf-json-${WF_JSON_COMMIT} subprojects/wf-json || die

		if use pulseaudio; then
			# bundled subproject for the volume widget
			# static, written to be used as a subproject
			rmdir subprojects/gvc || die
			mv "${WORKDIR}"/libgnome-volume-control-${GVC_COMMIT} subprojects/gvc || die
		fi
	fi
}

src_configure () {
	local emesonargs=(
		"$(meson_feature pipewire wp-mixer-widget)"
		"$(meson_feature pulseaudio volume-widget)"
		"$(meson_feature ddcutil)"
		-Dwayland-logout=false
		-Dweather=false
	)
	meson_src_configure
}
