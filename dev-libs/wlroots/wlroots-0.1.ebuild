# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://github.com/swaywm/wlroots.git"
	inherit git-r3
	KEYWORDS=""
else
	SRC_URI="https://github.com/swaywm/wlroots/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

inherit fcaps meson

DESCRIPTION="Pluggable, composable, unopinionated modules for building a Wayland compositor"
HOMEPAGE="https://github.com/swaywm/wlroots"
LICENSE="MIT"
SLOT="0"
IUSE="elogind examples filecaps png rootston systemd x11-backend xcb-icccm xcb-xkb xwayland"
REQUIRED_USE="systemd? ( !elogind )"

# An example requires >=ffmpeg-4.0 (actually masked) or equivalent libav
# (actually upstream is behind ffmpeg-4.0). So the ffmpeg use flag is actually
# not present and the related example (only one) will not be build. This is a
# reminder to add the 'ffmpeg' use flag when ffmpeg-4.0 will be unmasked.
# examples? ( ffmpeg? ( >=media-video/ffmpeg-4.0 ) )
RDEPEND=">=dev-libs/libinput-1.7.0
	>=dev-libs/wayland-1.16.0
	>=dev-libs/wayland-protocols-1.15
	media-libs/mesa[egl,gles2,gbm]
	virtual/libudev
	x11-libs/libdrm
	x11-libs/libxkbcommon
	x11-libs/pixman
	filecaps? ( sys-libs/libcap )
	elogind? ( >=sys-auth/elogind-237 )
	examples? (
		png? ( media-libs/libpng:* )
	)
	systemd? ( >=sys-apps/systemd-237 )
	x11-backend? (
		x11-libs/libxcb
		xcb-xkb? ( x11-libs/libxcb[xkb] )
	)
	xcb-icccm? ( x11-libs/xcb-util-wm )
	xcb-xkb? ( x11-libs/libxcb[xkb] )
	xwayland? (
		x11-base/xorg-server[wayland]
		x11-libs/libxcb
	)"
DEPEND="${RDEPEND}
	>=dev-util/meson-0.48
	virtual/pkgconfig"

FILECAPS=( cap_sys_admin usr/bin/rootston )

meson_feature_use() {
	usex "$1" "-D${2-$1}=enabled" "-D${2-$1}=disabled"
}

src_configure() {
	# xcb-util-errors is not on Gentoo Repository (and upstream seems inactive?)
	local emesonargs=(
		"-Dxcb-errors=disabled"
		$(meson_feature_use filecaps libcap)
		$(meson_feature_use xcb-icccm)
		$(meson_feature_use xcb-xkb)
		$(meson_feature_use xwayland)
		$(meson_feature_use x11-backend)
		$(meson_use rootston)
		$(meson_use examples)
	)
	if use systemd ; then
		emesonargs+=("-Dlogind=enabled" "-Dlogind-provider=systemd")
	elif use elogind ; then
		emesonargs+=("-Dlogind=enabled" "-Dlogind-provider=elogind")
	else
		emesonargs+=("-Dlogind=disabled")
	fi

	meson_src_configure
}

src_install() {
	if use rootston ; then
		dobin "${BUILD_DIR}"/rootston/rootston
		newdoc rootston/rootston.ini.example rootston.ini
		docompress -x usr/share/doc/"${PF}"/rootston.ini
	fi

	if use examples ; then
		einfo "Installing examples in /usr/share/doc/${PF}/examples/"
		find "${BUILD_DIR}"/examples/* -type d -print0 | xargs -0 rm -rf
		exeinto /usr/share/doc/"${PF}"/examples/
		doexe "${BUILD_DIR}"/examples/*
		docompress -x usr/share/doc/"${PF}"/examples/
	fi

	meson_src_install
}

pkg_postinst() {
	if use rootston ; then
		elog "You should copy the ${EROOT:-${ROOT}}usr/share/doc/${PF}/rootston.ini"
		elog "example configuration file to the working directory from where you"
		elog "launch rootston (or pass the '-C path-to-config' option to rootston)."
		elog ""
	fi
	elog "You must be in the input group to allow your compositor"
	elog "to access input devices via libinput."
	if ! use systemd && ! use elogind ; then
		if use examples ; then
			fcaps cap_sys_admin "${EROOT:-${ROOT}}"usr/share/doc/"${PF}"/examples/*
		fi
		if use rootston ; then
			fcaps_pkg_postinst
			elog ""
			elog "If you use ConsoleKit2, remember to launch rootston using:"
			elog "exec ck-launch-session rootston"
		fi
	fi
}
