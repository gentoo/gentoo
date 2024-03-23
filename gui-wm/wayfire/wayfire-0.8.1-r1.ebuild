# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="compiz like 3D wayland compositor"
HOMEPAGE="https://github.com/WayfireWM/wayfire"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/WayfireWM/${PN}.git"
	SLOT="0/0.8"
else
	SRC_URI="https://github.com/WayfireWM/${PN}/releases/download/v${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm64 ~riscv"
	SLOT="0/$(ver_cut 1-2)"
fi

LICENSE="MIT"
IUSE="+gles3 test X"
RESTRICT="!test? ( test )"

# bundled wlroots has the following dependency string according to included headers.
# wlroots[drm,gles2-renderer,libinput,x11-backend?,X?]
# enable x11-backend with X and vice versa
CDEPEND="
	dev-cpp/nlohmann_json
	dev-libs/glib:2
	dev-libs/libevdev
	>=dev-libs/libinput-1.7.0:=
	dev-libs/wayland
	>=dev-libs/wayland-protocols-1.12
	gui-libs/wf-config:${SLOT}
	gui-libs/wlroots:0/17[drm(+),libinput(+),x11-backend,X?]
	media-libs/glm
	media-libs/libglvnd
	media-libs/libjpeg-turbo:=
	media-libs/libpng:=
	x11-libs/cairo
	x11-libs/libxkbcommon
	x11-libs/pango
	x11-libs/pixman
	X? (
		x11-libs/libxcb:=
	)
"

RDEPEND="
	${CDEPEND}
	x11-misc/xkeyboard-config
"
DEPEND="
	${CDEPEND}
	test? ( dev-cpp/doctest )
"
BDEPEND="
	dev-util/wayland-scanner
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}/wayfire-0.8.0-dont-use-installed-config-h.patch"
)

src_prepare() {
	default

	sed -e "s:@EPREFIX@:${EPREFIX}:" \
		"${FILESDIR}"/wayfire-session > "${T}"/wayfire-session || die
	sed -e "s:@EPREFIX@:${EPREFIX}:" \
		"${FILESDIR}"/wayfire-session.desktop > "${T}"/wayfire-session.desktop || die
}

src_configure() {
	local emesonargs=(
		$(meson_feature test tests)
		$(meson_feature X xwayland)
		$(meson_use gles3 enable_gles32)
		-Duse_system_wfconfig=enabled
		-Duse_system_wlroots=enabled
	)

	meson_src_configure
}

src_install() {
	meson_src_install
	dobin "${T}"/wayfire-session

	insinto "/usr/share/wayland-sessions/"
	insopts -m644
	doins wayfire.desktop
	doins "${T}"/wayfire-session.desktop

	insinto "/usr/share/wayfire/"
	doins wayfire.ini
}

pkg_postinst() {
	if [ -z "${REPLACING_VERSIONS}" ]; then
		elog "Wayfire has been installed but the session cannot be used"
		elog "until you install a configuration file. The default config"
		elog "file is installed at \"/usr/share/wayfire/wayfire.ini\""
		elog "To install the file execute"
		elog "\$ cp /usr/share/wayfire/wayfire.ini ~/.config/wayfire.ini"
	fi
}
