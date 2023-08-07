# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://gitlab.freedesktop.org/wayland/weston.git"
	GIT_ECLASS="git-r3"
	EXPERIMENTAL="true"
fi

PYTHON_COMPAT=( python3_{9..12} )
inherit meson python-any-r1 readme.gentoo-r1 xdg-utils ${GIT_ECLASS}

DESCRIPTION="Wayland reference compositor"
HOMEPAGE="https://wayland.freedesktop.org/ https://gitlab.freedesktop.org/wayland/weston"

if [[ ${PV} = *9999* ]]; then
	SRC_URI="${SRC_PATCHES}"
else
	SRC_URI="https://gitlab.freedesktop.org/wayland/${PN}/-/releases/${PV}/downloads/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm ~arm64 ~ia64 ~loong ~riscv ~x86"
fi

LICENSE="MIT CC-BY-SA-3.0"
SLOT="0"

IUSE="+desktop +drm editor examples fullscreen +gles2 headless ivi jpeg kiosk lcms pipewire rdp remoting +resize-optimization screen-sharing +suid systemd test vnc wayland-compositor webp +X xwayland"
RESTRICT="!test? ( test )"

REQUIRED_USE="
	drm? ( gles2 )
	pipewire? ( drm )
	remoting? ( drm gles2 )
	screen-sharing? ( rdp )
	test? ( desktop headless lcms xwayland )
	wayland-compositor? ( gles2 )
	|| ( drm headless rdp vnc wayland-compositor X )
"

RDEPEND="
	>=dev-libs/libinput-1.2.0
	>=dev-libs/wayland-1.20.0
	media-libs/libpng:0=
	sys-auth/seatd:=
	>=x11-libs/cairo-1.11.3
	>=x11-libs/libdrm-2.4.108
	>=x11-libs/libxkbcommon-0.5.0
	>=x11-libs/pixman-0.25.2
	x11-misc/xkeyboard-config
	drm? (
		>=media-libs/mesa-17.1[gbm(+)]
		>=sys-libs/mtdev-1.1.0
		>=virtual/udev-136
	)
	editor? ( x11-libs/pango )
	examples? ( x11-libs/pango )
	gles2? ( media-libs/mesa[gles2,wayland] )
	jpeg? ( media-libs/libjpeg-turbo:0= )
	lcms? ( >=media-libs/lcms-2.9:2 )
	pipewire? ( >=media-video/pipewire-0.3:= )
	rdp? ( >=net-misc/freerdp-2.3.0:=[server] )
	remoting? (
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-base:1.0
	)
	systemd? ( sys-apps/systemd )
	vnc? (
		=dev-libs/aml-0.3*
		=gui-libs/neatvnc-0.6*
		sys-libs/pam
	)
	webp? ( media-libs/libwebp:0= )
	X? (
		>=x11-libs/libxcb-1.9
		x11-libs/libX11
	)
	xwayland? (
		x11-base/xwayland
		x11-libs/cairo[X,xcb(+)]
		>=x11-libs/libxcb-1.9
		x11-libs/libXcursor
		>=x11-libs/xcb-util-cursor-0.1.4
	)
"
DEPEND="${RDEPEND}
	>=dev-libs/wayland-protocols-1.24
"
BDEPEND="
	${PYTHON_DEPS}
	dev-util/wayland-scanner
	virtual/pkgconfig
	$(python_gen_any_dep 'dev-python/setuptools[${PYTHON_USEDEP}]')
"

src_configure() {
	local emesonargs=(
		$(meson_use drm backend-drm)
		-Dbackend-drm-screencast-vaapi=false
		$(meson_use headless backend-headless)
		$(meson_use pipewire backend-pipewire)
		$(meson_use rdp backend-rdp)
		$(meson_use screen-sharing screenshare)
		$(meson_use vnc backend-vnc)
		$(meson_use wayland-compositor backend-wayland)
		$(meson_use X backend-x11)
		-Dbackend-default=auto
		$(meson_use gles2 renderer-gl)
		$(meson_use xwayland)
		-Dlauncher-libseat=true
		$(meson_use systemd)
		$(meson_use remoting)
		$(meson_use pipewire)
		$(meson_use desktop shell-desktop)
		$(meson_use fullscreen shell-fullscreen)
		$(meson_use ivi shell-ivi)
		$(meson_use kiosk shell-kiosk)
		$(meson_use lcms color-management-lcms)
		$(meson_use jpeg image-jpeg)
		$(meson_use webp image-webp)
		-Dtools=debug,info,terminal
		$(meson_use examples demo-clients)
		-Dsimple-clients=$(usex examples damage,dmabuf-v4l,im,shm,touch$(usex gles2 ,dmabuf-egl,egl "") "")
		$(meson_use resize-optimization resize-pool)
		-Dtest-junit-xml=false
		"${myconf[@]}"
	)
	meson_src_configure
}

src_test() {
	xdg_environment_reset
	addwrite /dev/dri/

	# xwayland test can fail if X11 socket already exists.
	cd "${BUILD_DIR}" || die
	meson test $(meson test --list | grep -Exv "xwayland") || die
}

src_install() {
	meson_src_install
	readme.gentoo_create_doc
}
