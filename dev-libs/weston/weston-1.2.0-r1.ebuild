# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="git://anongit.freedesktop.org/git/wayland/${PN}"
	GIT_ECLASS="git-2"
	EXPERIMENTAL="true"
fi
VIRTUALX_REQUIRED="test"

inherit autotools readme.gentoo toolchain-funcs virtualx $GIT_ECLASS

DESCRIPTION="Wayland reference compositor"
HOMEPAGE="http://wayland.freedesktop.org/"

if [[ $PV = 9999* ]]; then
	SRC_URI="${SRC_PATCHES}"
	KEYWORDS=""
else
	SRC_URI="http://wayland.freedesktop.org/releases/${P}.tar.xz"
	KEYWORDS="~arm ~amd64 ~x86 ~arm-linux"
fi

LICENSE="MIT CC-BY-SA-3.0"
SLOT="0"
IUSE="colord +drm +egl editor examples fbdev gles2 headless +opengl rdp +resize-optimization rpi static-libs +suid systemd tablet test unwind view wayland-compositor +X xwayland"

REQUIRED_USE="
	drm? ( egl )
	editor? ( examples )
	egl? ( || ( gles2 opengl ) )
	fbdev? ( drm )
	gles2? ( !opengl )
	test? ( X )
	view? ( examples )
	wayland-compositor? ( egl )
"

RDEPEND="
	>=dev-libs/wayland-1.1.90
	media-libs/mesa[egl?,wayland]
	media-libs/lcms:2
	media-libs/libpng:=
	media-libs/libwebp
	virtual/jpeg
	sys-libs/pam
	>=x11-libs/cairo-1.11.3[gles2(-)?,opengl?]
	>=x11-libs/libdrm-2.4.30
	x11-libs/libxkbcommon
	x11-libs/pixman
	fbdev? (
		>=sys-libs/mtdev-1.1.0
		>=virtual/udev-136
	)
	colord? ( >=x11-misc/colord-0.1.27 )
	drm? (
		media-libs/mesa[gbm]
		>=sys-libs/mtdev-1.1.0
		>=virtual/udev-136
	)
	egl? (
		media-libs/glu
		media-libs/mesa[gles2]
	)
	examples? (
		editor? ( x11-libs/pango )
		view? (
			app-text/poppler:=[cairo]
			dev-libs/glib:2
		)
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
	unwind? ( sys-libs/libunwind )
	X? (
		x11-libs/libxcb
		x11-libs/libX11
	)
	xwayland? (
		x11-libs/cairo[xcb]
		x11-libs/libxcb
		x11-libs/libXcursor
	)
"
DEPEND="${RDEPEND}
	gnome-base/librsvg
	virtual/pkgconfig
"

src_prepare() {
	if [[ ${PV} = 9999* ]]; then
		eautoreconf
	fi
}

src_configure() {
	local myconf
	if use examples || use gles2 || use test; then
		myconf="--enable-simple-clients
			$(use_enable egl simple-egl-clients)"
	else
		myconf="--disable-simple-clients
			--disable-simple-egl-clients"
	fi
	econf \
		$(use_enable fbdev fbdev-compositor) \
		$(use_enable drm drm-compositor) \
		$(use_enable headless headless-compositor) \
		$(use_enable rdp rdp-compositor) \
		$(use_enable rpi rpi-compositor) \
		$(use_enable wayland-compositor) \
		$(use_enable X x11-compositor) \
		$(use_enable colord) \
		$(use_enable egl) \
		$(use_enable unwind libunwind) \
		$(use_with gles2 cairo-glesv2) \
		$(use_enable resize-optimization) \
		$(use_enable suid setuid-install) \
		$(use_enable tablet tablet-shell) \
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

	cd "${BUILD_DIR}" || die
	if use opengl && use egl; then
		newbin clients/gears weston-gears
	fi
	if use examples; then
		use egl && newbin clients/simple-egl weston-simple-egl
		use editor && newbin clients/editor weston-editor
		use view && newbin clients/view weston-view
		local i
		for i in calibrator clickdot cliptest dnd eventdemo flower fullscreen image resizor simple-shm simple-touch smoke transformed; do
			newbin "clients/${i}" "weston-${i}"
		done
	fi
}
