# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://gitlab.freedesktop.org/wayland/weston.git"
	GIT_ECLASS="git-r3"
	EXPERIMENTAL="true"
fi

inherit autotools readme.gentoo-r1 toolchain-funcs $GIT_ECLASS

DESCRIPTION="Wayland reference compositor"
HOMEPAGE="https://wayland.freedesktop.org/ https://gitlab.freedesktop.org/wayland/weston"

if [[ $PV = 9999* ]]; then
	SRC_URI="${SRC_PATCHES}"
	KEYWORDS="amd64 arm x86"
else
	SRC_URI="https://wayland.freedesktop.org/releases/${P}.tar.xz"
	KEYWORDS="amd64 arm x86"
fi

LICENSE="MIT CC-BY-SA-3.0"
SLOT="0"

IUSE="colord dbus +drm editor examples fbdev +gles2 headless ivi jpeg +launch lcms rdp +resize-optimization screen-sharing static-libs +suid systemd test unwind wayland-compositor webp +X xwayland"
RESTRICT="!test? ( test )"

REQUIRED_USE="
	drm? ( gles2 )
	screen-sharing? ( rdp )
	systemd? ( dbus )
	test? ( headless xwayland )
	wayland-compositor? ( gles2 )
"

RDEPEND="
	>=dev-libs/libinput-0.8.0
	>=dev-libs/wayland-1.12.0
	>=dev-libs/wayland-protocols-1.8
	lcms? ( media-libs/lcms:2 )
	media-libs/libpng:0=
	webp? ( media-libs/libwebp:0= )
	jpeg? ( virtual/jpeg:0= )
	>=x11-libs/cairo-1.11.3
	>=x11-libs/libdrm-2.4.30
	>=x11-libs/libxkbcommon-0.5.0
	>=x11-libs/pixman-0.25.2
	x11-misc/xkeyboard-config
	fbdev? (
		>=sys-libs/mtdev-1.1.0
		>=virtual/udev-136
	)
	colord? ( >=x11-misc/colord-0.1.27 )
	dbus? ( >=sys-apps/dbus-1.6 )
	drm? (
		media-libs/mesa[gbm]
		>=sys-libs/mtdev-1.1.0
		>=virtual/udev-136
	)
	editor? ( x11-libs/pango )
	gles2? (
		media-libs/mesa[gles2,wayland]
	)
	rdp? ( >=net-misc/freerdp-1.1.0_beta1_p20130710 )
	systemd? (
		sys-auth/pambase[systemd]
		>=sys-apps/systemd-209[pam]
	)
	launch? ( sys-auth/pambase )
	unwind? ( sys-libs/libunwind )
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

src_prepare() {
	default
	if [[ ${PV} = 9999* ]]; then
		eautoreconf
	else
		elibtoolize
	fi
}

src_configure() {
	local myconf
	if use examples || use test; then
		myconf="--enable-simple-clients"
	else
		myconf="--disable-simple-clients"
	fi

	econf \
		$(use_enable examples demo-clients-install) \
		$(use_enable fbdev fbdev-compositor) \
		$(use_enable dbus) \
		$(use_enable drm drm-compositor) \
		$(use_enable headless headless-compositor) \
		$(use_enable ivi ivi-shell) \
		$(use_enable lcms) \
		$(use_enable rdp rdp-compositor) \
		$(use_enable wayland-compositor) \
		$(use_enable X x11-compositor) \
		$(use_enable launch weston-launch) \
		$(use_enable colord) \
		$(use_enable gles2 egl) \
		$(use_enable unwind libunwind) \
		$(use_enable resize-optimization) \
		$(use_enable screen-sharing) \
		$(use_enable suid setuid-install) \
		$(use_enable systemd systemd-login) \
		$(use_enable systemd systemd-notify) \
		$(use_enable xwayland) \
		$(use_enable xwayland xwayland-test) \
		$(use_with jpeg) \
		$(use_with webp) \
		--with-cairo=image \
		--disable-junit-xml \
		--disable-simple-dmabuf-drm-client \
		--disable-simple-dmabuf-v4l-client \
		--disable-simple-egl-clients \
		--disable-vaapi-recorder \
		${myconf}
}

src_test() {
	export XDG_RUNTIME_DIR="${T}/runtime-dir"
	mkdir "${XDG_RUNTIME_DIR}" || die
	chmod 0700 "${XDG_RUNTIME_DIR}" || die

	cd "${BUILD_DIR}" || die
	emake check
}

src_install() {
	default

	readme.gentoo_create_doc
}
