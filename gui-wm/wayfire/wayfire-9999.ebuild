# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="compiz like 3D wayland compositor"
HOMEPAGE="https://github.com/WayfireWM/wayfire"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/WayfireWM/${PN}.git"
else
	SRC_URI="https://github.com/WayfireWM/${PN}/releases/download/v${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm64 ~x86"
fi

LICENSE="MIT"
SLOT="0"
IUSE="+system-wfconfig +system-wlroots X"

DEPEND="
	dev-libs/libevdev
	dev-libs/libinput
	gui-libs/gtk-layer-shell
	media-libs/glm
	media-libs/mesa:=[gles2,wayland,X?]
	media-libs/libglvnd[X?]
	media-libs/libjpeg-turbo
	media-libs/libpng
	media-libs/freetype:=[X?]
	media-video/ffmpeg
	x11-libs/libdrm
	x11-libs/gtk+:3=[wayland,X?]
	x11-libs/cairo:=[X?,svg]
	x11-libs/libinotify
	x11-libs/pixman
	system-wfconfig? ( >=gui-libs/wf-config-${PV%.*} )
	!system-wfconfig? ( !gui-libs/wf-config )
	system-wlroots? ( >=gui-libs/wlroots-0.13.0[X?] )
	!system-wlroots? ( !gui-libs/wlroots )
	X? ( x11-libs/libxkbcommon:=[X] )
"

RDEPEND="
	${DEPEND}
	x11-misc/xkeyboard-config
"

BDEPEND="
	dev-libs/wayland-protocols
	virtual/pkgconfig
"

src_configure() {
	sed -e "s:@EPREFIX@:${EPREFIX}:" \
	    "${FILESDIR}"/wayfire-session > "${T}"/wayfire-session || die
	sed -e "s:@EPREFIX@:${EPREFIX}:" \
	    "${FILESDIR}"/wayfire-session.desktop > "${T}"/wayfire-session.desktop || die
	local emesonargs=(
		-Denable_gles32=true
		$(meson_feature system-wfconfig use_system_wfconfig)
		$(meson_feature system-wlroots use_system_wlroots)
		$(meson_feature X xwayland)
	)
	meson_src_configure
}

src_install() {
	default
	meson_src_install
	dobin "${T}"/wayfire-session
	einstalldocs

	insinto "/usr/share/wayland-sessions/"
	insopts -m644
	doins wayfire.desktop
	doins "${T}"/wayfire-session.desktop

	dodoc wayfire.ini
	docompress -x /usr/share/doc/${PF}/wayfire.ini
}

pkg_postinst() {
	if [ -z "${REPLACING_VERSIONS}" ]; then
		elog "Wayfire has been installed but the session cannot be used"
		elog "until you install a configuration file. The default config"
		elog "file is installed at \"/usr/share/doc/${PF}/wayfire.ini\""
		elog "To install the file execute"
		elog "\$ mkdir -p ~/.config && cp /usr/share/doc/${PF}/wayfire.ini ~/.config/wayfire.ini"
	fi
}
