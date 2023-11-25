# Copyright 2019-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson toolchain-funcs

DESCRIPTION="compiz like 3D wayland compositor"
HOMEPAGE="https://github.com/WayfireWM/wayfire"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/WayfireWM/${PN}.git"
	SLOT="0/9999"
else
	SRC_URI="https://github.com/WayfireWM/${PN}/releases/download/v${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm64 ~riscv ~x86"
	SLOT="0/$(ver_cut 1-2)"
fi

LICENSE="MIT"
IUSE="debug +gles +system-wfconfig +system-wlroots test X"
RESTRICT="!test? ( test )"

# bundled wlroots has the following dependency string according to included headers.
# wlroots[drm,gles2-renderer,libinput,x11-backend?,X?]
# enable x11-backend with X and vice versa
WLROOTS_CDEPEND="
	>=dev-libs/libinput-1.14.0:=
	>=dev-libs/wayland-1.22
	media-libs/libdisplay-info
	media-libs/libglvnd
	media-libs/mesa[egl(+),gles2]
	sys-apps/hwdata:=
	sys-auth/seatd:=
	>=x11-libs/libdrm-2.4.114:=
	x11-libs/libxkbcommon
	>=x11-libs/pixman-0.42.0
	virtual/libudev
	X? (
		x11-base/xwayland
		x11-libs/libxcb:0=
		x11-libs/xcb-util-image
		x11-libs/xcb-util-renderutil
		x11-libs/xcb-util-wm
	)
"
WLROOTS_DEPEND="
	>=dev-libs/wayland-protocols-1.32
"
WLROOTS_BDEPEND="
	dev-util/glslang
	dev-util/wayland-scanner
"

CDEPEND="
	dev-cpp/nlohmann_json
	dev-libs/libevdev
	>=dev-libs/libinput-1.7.0
	dev-libs/wayland
	>=dev-libs/wayland-protocols-1.12
	media-libs/glm
	media-libs/libglvnd
	media-libs/libjpeg-turbo
	media-libs/libpng
	x11-libs/cairo
	x11-libs/libdrm
	x11-libs/libxkbcommon
	x11-libs/pango
	x11-libs/pixman
	system-wfconfig? ( gui-libs/wf-config:${SLOT} )
	!system-wfconfig? ( dev-libs/libxml2 )
	!system-wlroots? ( ${WLROOTS_CDEPEND} )
"

if [[ ${PV} == 9999 ]] ; then
	CDEPEND+="
		system-wlroots? ( gui-libs/wlroots:0/9999[drm(+),libinput(+),x11-backend,X?] )
	"
else
	CDEPEND+="
		system-wlroots? ( gui-libs/wlroots:0/16[drm(+),libinput(+),x11-backend,X?] )
	"
fi

RDEPEND="
	${CDEPEND}
	x11-misc/xkeyboard-config
	!system-wfconfig? ( !gui-libs/wf-config )
	!system-wlroots? ( !gui-libs/wlroots )
"
DEPEND="
	${CDEPEND}
	!system-wlroots? ( ${WLROOTS_DEPEND} )
	test? ( dev-cpp/doctest )
"
BDEPEND="
	dev-util/wayland-scanner
	virtual/pkgconfig
	!system-wlroots? ( ${WLROOTS_BDEPEND} )
"

src_prepare() {
	eapply_user

	sed -e "s:@EPREFIX@:${EPREFIX}:" \
		"${FILESDIR}"/wayfire-session > "${T}"/wayfire-session || die
	sed -e "s:@EPREFIX@:${EPREFIX}:" \
		"${FILESDIR}"/wayfire-session.desktop > "${T}"/wayfire-session.desktop || die

	if [[ "${PV}" != 9999 ]]; then
		# Don't run git if git is installed and its not a git dir
		sed -i \
			-e "/git = find_program/ifs = import\('fs'\)" \
			-e "s/if git.found()/if git.found() and fs.is_dir('.git')/" \
			meson.build || die
	fi

}

src_configure() {
	local emesonargs=(
		$(meson_feature system-wfconfig use_system_wfconfig)
		$(meson_feature system-wlroots use_system_wlroots)
		$(meson_feature test tests)
		$(meson_feature X xwayland)
		$(meson_use gles enable_gles32)
		$(usex debug --buildtype=debug "")
		$(usex debug -Db_sanitize=address,undefined "")
	)

	# Clang will fail to link without this
	tc-is-clang && emesonargs+=( $(usex debug -Db_lundef=false "") )

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
