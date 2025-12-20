# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-4 )
PYTHON_COMPAT=( python3_{10..14} )

inherit lua-single meson python-any-r1 readme.gentoo-r1 xdg-utils

DESCRIPTION="Wayland reference compositor"
HOMEPAGE="https://wayland.freedesktop.org"

if [[ ${PV} = *9999* ]]; then
	EGIT_REPO_URI="https://gitlab.freedesktop.org/wayland/weston.git"
	inherit git-r3
else
	SRC_URI="https://gitlab.freedesktop.org/wayland/${PN}/-/releases/${PV}/downloads/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"
fi

LICENSE="MIT CC-BY-SA-3.0"
SLOT="0"

IUSE="+desktop +drm editor examples +gles2 headless ivi jpeg kiosk lcms lua pipewire rdp remoting +resize-optimization +suid systemd test vnc vulkan wayland-compositor webp +X xwayland"
RESTRICT="!test? ( test )"

REQUIRED_USE="
	drm? ( gles2 )
	lua? ( ${LUA_REQUIRED_USE} )
	pipewire? ( drm )
	remoting? ( drm gles2 )
	test? ( headless )
	wayland-compositor? ( gles2 )
	|| ( drm headless rdp vnc wayland-compositor X )
"

RDEPEND="
	>=dev-libs/libinput-1.2.0
	>=dev-libs/wayland-1.22.0
	media-libs/libpng:0=
	sys-auth/seatd:=
	>=x11-libs/cairo-1.11.3
	>=x11-libs/libdrm-2.4.108
	>=x11-libs/libxkbcommon-0.5.0
	>=x11-libs/pixman-0.25.2
	x11-misc/xkeyboard-config
	drm? (
		<media-libs/libdisplay-info-0.4.0:=
		>=media-libs/mesa-21.1.1
		>=sys-libs/mtdev-1.1.0
		>=virtual/udev-136
	)
	editor? ( x11-libs/pango )
	examples? (
		dev-libs/glib:2
		x11-libs/pango
		gles2? (
			>=media-libs/mesa-21.1.1
			>=virtual/udev-136
		)
	)
	gles2? ( media-libs/libglvnd )
	jpeg? ( media-libs/libjpeg-turbo:0= )
	lcms? ( >=media-libs/lcms-2.9:2 )
	lua? ( ${LUA_DEPS} )
	pipewire? ( >=media-video/pipewire-0.3:= )
	rdp? ( >=net-misc/freerdp-2.3.0:=[server] )
	remoting? (
		dev-libs/glib:2
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-base:1.0
	)
	systemd? ( sys-apps/systemd )
	vnc? (
		=dev-libs/aml-0.3*
		>=gui-libs/neatvnc-0.8.1
		<gui-libs/neatvnc-0.10.0
		sys-libs/pam
	)
	vulkan? (
		>=media-libs/mesa-21.1.1
		media-libs/vulkan-loader
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
	>=dev-libs/wayland-protocols-1.46
"
BDEPEND="
	${PYTHON_DEPS}
	dev-util/wayland-scanner
	virtual/pkgconfig
	vulkan? ( dev-util/glslang )
"

pkg_setup() {
	python-any-r1_pkg_setup
	use lua && lua-single_pkg_setup
}

src_configure() {
	local emesonargs=(
		$(meson_use drm backend-drm)
		$(meson_use headless backend-headless)
		$(meson_use pipewire backend-pipewire)
		$(meson_use rdp backend-rdp)
		$(meson_use vnc backend-vnc)
		$(meson_use vulkan renderer-vulkan)
		$(meson_use wayland-compositor backend-wayland)
		$(meson_use X backend-x11)
		-Dbackend-default=auto
		$(meson_use gles2 renderer-gl)
		$(meson_use xwayland)
		$(meson_use systemd)
		$(meson_use remoting)
		$(meson_use pipewire)
		$(meson_use desktop shell-desktop)
		$(meson_use ivi shell-ivi)
		$(meson_use lua shell-lua)
		$(meson_use kiosk shell-kiosk)
		$(meson_use lcms color-management-lcms)
		$(meson_use jpeg image-jpeg)
		$(meson_use webp image-webp)
		-Dtools=debug,info,terminal
		$(meson_use examples demo-clients)
		-Dsimple-clients=$(usex examples damage,dmabuf-v4l,im,shm,touch$(usex gles2 ,dmabuf-feedback,dmabuf-egl,egl "") "")
		$(meson_use resize-optimization resize-pool)
		$(meson_use test tests)
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
