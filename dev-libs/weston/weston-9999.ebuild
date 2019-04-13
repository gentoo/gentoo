# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://gitlab.freedesktop.org/wayland/weston.git"
	GIT_ECLASS="git-r3"
	EXPERIMENTAL="true"
fi

inherit meson readme.gentoo-r1 toolchain-funcs $GIT_ECLASS

DESCRIPTION="Wayland reference compositor"
HOMEPAGE="https://wayland.freedesktop.org/ https://gitlab.freedesktop.org/wayland/weston"

if [[ $PV = 9999* ]]; then
	SRC_URI="${SRC_PATCHES}"
	KEYWORDS=""
else
	SRC_URI="https://wayland.freedesktop.org/releases/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm ~x86"
fi

LICENSE="MIT CC-BY-SA-3.0"
SLOT="0"

IUSE="colord +drm editor examples fbdev +gles2 headless ivi jpeg +launch lcms rdp remoting +resize-optimization screen-sharing static-libs +suid systemd test wayland-compositor webp +X xwayland"

REQUIRED_USE="
	drm? ( gles2 )
	screen-sharing? ( rdp )
	test? ( headless xwayland )
	wayland-compositor? ( gles2 )
"

RDEPEND="
	>=dev-libs/libinput-0.8.0
	>=dev-libs/wayland-1.17.0
	>=dev-libs/wayland-protocols-1.17
	lcms? ( media-libs/lcms:2 )
	media-libs/libpng:0=
	webp? ( media-libs/libwebp:0= )
	jpeg? ( virtual/jpeg:0= )
	>=x11-libs/cairo-1.11.3
	>=x11-libs/libdrm-2.4.68
	>=x11-libs/libxkbcommon-0.5.0
	>=x11-libs/pixman-0.25.2
	x11-misc/xkeyboard-config
	fbdev? (
		>=sys-libs/mtdev-1.1.0
		>=virtual/udev-136
	)
	colord? ( >=x11-misc/colord-0.1.27 )
	drm? (
		>=media-libs/mesa-17.1[gbm]
		>=sys-libs/mtdev-1.1.0
		>=virtual/udev-136
	)
	editor? ( x11-libs/pango )
	gles2? (
		media-libs/mesa[gles2,wayland]
	)
	rdp? ( >=net-misc/freerdp-1.1.0:= )
	remoting? (
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-base:1.0
	)
	systemd? (
		sys-auth/pambase[systemd]
		>=sys-apps/dbus-1.6
		>=sys-apps/systemd-209[pam]
	)
	launch? ( sys-auth/pambase )
	X? (
		>=x11-libs/libxcb-1.9
		x11-libs/libX11
	)
	xwayland? (
		x11-base/xorg-server[wayland]
		x11-libs/cairo[xcb]
		>=x11-libs/libxcb-1.9
		x11-libs/libXcursor
	)
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

src_configure() {
	local emesonargs=(
		$(meson_use drm backend-drm)
		-Dbackend-drm-screencast-vaapi=false
		$(meson_use headless backend-headless)
		$(meson_use rdp backend-rdp)
		$(meson_use screen-sharing screenshare)
		$(meson_use X backend-x11)
		$(meson_use fbdev backend-fbdev)
		$(meson_use gles2 renderer-gl)
		$(meson_use launch weston-launch)
		$(meson_use xwayland)
		$(meson_use systemd)
		$(meson_use remoting)
		$(meson_use wayland-compositor shell-desktop)
		$(meson_use ivi shell-ivi)
		$(meson_use lcms color-management-lcms)
		$(meson_use colord color-management-colord)
		$(meson_use systemd launcher-logind)
		$(meson_use jpeg image-jpeg)
		$(meson_use webp image-webp)
		-Dtools=debug,info,terminal
		-Dsimple-dmabuf-drm=auto
		$(meson_use examples demo-clients)
		$(usex examples -Dsimple-clients=damage,img,egl,shm,touch "")
		$(meson_use resize-optimization resize-pool)
		-Dtest-junit-xml=false
		"${myconf[@]}"
	)
	meson_src_configure
}

src_test() {
	export XDG_RUNTIME_DIR="${T}/runtime-dir"
	mkdir "${XDG_RUNTIME_DIR}" || die
	chmod 0700 "${XDG_RUNTIME_DIR}" || die
	cd "${BUILD_DIR}" || die
	meson_src_test
}

src_install() {
	meson_src_install
	if use launch && use suid; then
		chmod u+s "${ED}"/usr/bin/weston-launch || die
	fi
	readme.gentoo_create_doc
}
