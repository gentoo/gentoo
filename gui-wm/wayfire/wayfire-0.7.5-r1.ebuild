# Copyright 2019-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson toolchain-funcs

DESCRIPTION="compiz like 3D wayland compositor"
HOMEPAGE="https://github.com/WayfireWM/wayfire"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/WayfireWM/${PN}.git"
else
	SRC_URI="https://github.com/WayfireWM/${PN}/releases/download/v${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm64 ~riscv ~x86"
fi

LICENSE="MIT"
SLOT="0"
IUSE="debug +gles +system-wfconfig +system-wlroots X"

DEPEND="
	dev-libs/libinput:=
	dev-libs/wayland
	gui-libs/gtk-layer-shell
	media-libs/glm
	media-libs/mesa:=[gles2,wayland,X?]
	media-libs/libglvnd[X?]
	media-libs/libjpeg-turbo:=
	media-libs/libpng:=
	media-libs/freetype:=[X?]
	x11-libs/libdrm
	x11-libs/gtk+:3=[wayland,X?]
	x11-libs/cairo[X?,svg(+)]
	x11-libs/libxkbcommon[X?]
	x11-libs/pango
	x11-libs/pixman
	X? (
		x11-base/xwayland
		x11-libs/libxcb
	)
"

if [[ ${PV} == 9999 ]] ; then
	DEPEND+="
		system-wfconfig? ( ~gui-libs/wf-config-9999:= )
		!system-wfconfig? ( !gui-libs/wf-config )
		system-wlroots? ( ~gui-libs/wlroots-9999:=[drm(+),libinput(+),x11-backend,X?] )
		!system-wlroots? ( !gui-libs/wlroots )
	"
else
	DEPEND+="
		system-wfconfig? (
			>=gui-libs/wf-config-0.7.1
			<gui-libs/wf-config-0.8.0
		)
		!system-wfconfig? ( !gui-libs/wf-config )
		system-wlroots? (
			>=gui-libs/wlroots-0.16.0:0/16[drm(+),libinput(+),x11-backend,X?]
		)
		!system-wlroots? ( !gui-libs/wlroots )
	"
fi

RDEPEND="
	${DEPEND}
	x11-misc/xkeyboard-config
"

BDEPEND="
	dev-libs/wayland-protocols
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.7.5-gcc13.patch
)

src_configure() {
	sed -e "s:@EPREFIX@:${EPREFIX}:" \
	    "${FILESDIR}"/wayfire-session > "${T}"/wayfire-session || die
	sed -e "s:@EPREFIX@:${EPREFIX}:" \
	    "${FILESDIR}"/wayfire-session.desktop > "${T}"/wayfire-session.desktop || die
	local emesonargs=(
		$(meson_feature system-wfconfig use_system_wfconfig)
		$(meson_feature system-wlroots use_system_wlroots)
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
