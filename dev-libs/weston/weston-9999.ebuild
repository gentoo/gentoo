# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="git://anongit.freedesktop.org/git/wayland/${PN}"
	GIT_ECLASS="git-r3"
	EXPERIMENTAL="true"
fi
VIRTUALX_REQUIRED="test"
RESTRICT="test"

inherit autotools readme.gentoo toolchain-funcs virtualx $GIT_ECLASS

DESCRIPTION="Wayland reference compositor"
HOMEPAGE="http://wayland.freedesktop.org/"

if [[ $PV = 9999* ]]; then
	SRC_URI="${SRC_PATCHES}"
	KEYWORDS=""
else
	SRC_URI="http://wayland.freedesktop.org/releases/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm ~x86 ~arm-linux"
fi

LICENSE="MIT CC-BY-SA-3.0"
SLOT="0"
IUSE="colord dbus +drm editor examples fbdev +gles2 headless ivi rdp +resize-optimization rpi +launch screen-sharing static-libs +suid systemd test unwind wayland-compositor +X xwayland"

REQUIRED_USE="
	drm? ( gles2 )
	screen-sharing? ( rdp )
	test? ( X )
	wayland-compositor? ( gles2 )
"

RDEPEND="
	>=dev-libs/libinput-0.8.0
	>=dev-libs/wayland-1.9.0
	media-libs/lcms:2
	media-libs/libpng:0=
	media-libs/libwebp:0=
	virtual/jpeg:0=
	>=x11-libs/cairo-1.11.3
	>=x11-libs/libdrm-2.4.30
	x11-libs/libxkbcommon
	x11-libs/pixman
	x11-misc/xkeyboard-config
	fbdev? (
		>=sys-libs/mtdev-1.1.0
		>=virtual/udev-136
	)
	colord? ( >=x11-misc/colord-0.1.27 )
	dbus? ( sys-apps/dbus )
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
	rpi? (
		>=sys-libs/mtdev-1.1.0
		>=virtual/udev-136
	)
	systemd? (
		sys-auth/pambase[systemd]
		sys-apps/systemd[pam]
	)
	launch? ( sys-auth/pambase )
	unwind? ( sys-libs/libunwind )
	X? (
		x11-libs/libxcb
		x11-libs/libX11
	)
	xwayland? (
		x11-base/xorg-server[wayland]
		x11-libs/cairo[xcb]
		x11-libs/libxcb
		x11-libs/libXcursor
	)
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

src_prepare() {
	if [[ ${PV} = 9999* ]]; then
		eautoreconf
	fi
}

src_configure() {
	local myconf
	if use examples || use test; then
		myconf="--enable-simple-clients"
	else
		myconf="--disable-simple-clients"
	fi

	myconf+=" --with-cairo=image --disable-simple-egl-clients"

	econf \
		$(use_enable examples demo-clients-install) \
		$(use_enable fbdev fbdev-compositor) \
		$(use_enable dbus) \
		$(use_enable drm drm-compositor) \
		$(use_enable headless headless-compositor) \
		$(use_enable ivi ivi-shell) \
		$(use_enable rdp rdp-compositor) \
		$(use_enable rpi rpi-compositor) \
		$(use_enable wayland-compositor) \
		$(use_enable X x11-compositor) \
		$(use_enable launch weston-launch) \
		$(use_enable colord) \
		$(use_enable gles2 egl) \
		$(use_enable unwind libunwind) \
		$(use_enable resize-optimization) \
		$(use_enable screen-sharing) \
		$(use_enable suid setuid-install) \
		$(use_enable xwayland) \
		$(use_enable xwayland xwayland-test) \
		${myconf}
}

src_test() {
	export XDG_RUNTIME_DIR="${T}/runtime-dir"
	mkdir "${XDG_RUNTIME_DIR}" || die
	chmod 0700 "${XDG_RUNTIME_DIR}" || die

	cd "${BUILD_DIR}" || die
	Xemake check
}

src_install() {
	default

	readme.gentoo_src_install
}
