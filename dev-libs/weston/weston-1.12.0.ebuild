# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="git://anongit.freedesktop.org/git/wayland/${PN}"
	GIT_ECLASS="git-r3"
	EXPERIMENTAL="true"
fi
VIRTUALX_REQUIRED="test"
RESTRICT="test"

inherit autotools readme.gentoo-r1 toolchain-funcs virtualx $GIT_ECLASS

DESCRIPTION="Wayland reference compositor"
HOMEPAGE="https://wayland.freedesktop.org/"

if [[ $PV = 9999* ]]; then
	SRC_URI="${SRC_PATCHES}"
	KEYWORDS=""
else
	SRC_URI="https://wayland.freedesktop.org/releases/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm ~x86 ~arm-linux"
fi

LICENSE="MIT CC-BY-SA-3.0"
SLOT="0"

IUSE_VIDEO_CARDS="video_cards_intel video_cards_v4l"
IUSE="colord dbus +drm editor examples fbdev +gles2 headless ivi jpeg +launch lcms rdp +resize-optimization screen-sharing static-libs +suid systemd test unwind wayland-compositor webp +X xwayland ${IUSE_VIDEO_CARDS}"

REQUIRED_USE="
	drm? ( gles2 )
	screen-sharing? ( rdp )
	systemd? ( dbus )
	test? ( X )
	wayland-compositor? ( gles2 )
"

RDEPEND="
	dev-libs/libinput
	>=dev-libs/wayland-1.12.0
	dev-libs/wayland-protocols
	media-libs/libpng:0=
	x11-libs/cairo
	x11-libs/libdrm
	x11-libs/libxkbcommon
	x11-libs/pixman
	x11-misc/xkeyboard-config
	colord? ( x11-misc/colord )
	dbus? ( sys-apps/dbus )
	drm? (
		media-libs/mesa[gbm]
		sys-libs/mtdev
		virtual/udev
	)
	editor? ( x11-libs/pango )
	fbdev? (
		sys-libs/mtdev
		virtual/udev
	)
	gles2? (
		media-libs/mesa[gles2,wayland]
	)
	jpeg? ( virtual/jpeg:0= )
	rdp? ( net-misc/freerdp )
	systemd? (
		sys-auth/pambase[systemd]
		sys-apps/systemd[pam]
	)
	launch? ( sys-auth/pambase )
	lcms? ( media-libs/lcms:2 )
	unwind? ( sys-libs/libunwind )
	webp? ( media-libs/libwebp:0= )
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

	myconf+=" --with-cairo=image --disable-simple-egl-clients"

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
		$(use_enable video_cards_intel simple-dmabuf-intel-client) \
		$(use_enable video_cards_v4l simple-dmabuf-v4l-client) \
		$(use_with jpeg) \
		$(use_with webp) \
		${myconf}
}

src_test() {
	export XDG_RUNTIME_DIR="${T}/runtime-dir"
	mkdir "${XDG_RUNTIME_DIR}" || die
	chmod 0700 "${XDG_RUNTIME_DIR}" || die

	cd "${BUILD_DIR}" || die
	virtx emake check
}

src_install() {
	default

	readme.gentoo_create_doc
}
