# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

SRC_URI="https://github.com/Aetf/kmscon/releases/download/v${PV}/${P}.tar.xz"
KEYWORDS="~amd64 ~x86"

inherit meson flag-o-matic toolchain-funcs

DESCRIPTION="KMS/DRM based virtual Console Emulator"
HOMEPAGE="https://github.com/Aetf/kmscon"

LICENSE="MIT LGPL-2.1 BSD-2"
SLOT="0"
IUSE="debug doc +drm +fbdev +gles2 +pango pixman systemd +unicode"

COMMON_DEPEND="
	>=virtual/udev-172
	x11-libs/libxkbcommon
	>=dev-libs/libtsm-4.0.0:=
	media-libs/mesa[X(+)]
	drm? ( x11-libs/libdrm
		>=media-libs/mesa-8.0.3[egl(+),gbm(+)] )
	gles2? ( >=media-libs/mesa-8.0.3[gles2] )
	systemd? ( sys-apps/systemd )
	pango? ( x11-libs/pango dev-libs/glib:2 )
	pixman? ( x11-libs/pixman )"
RDEPEND="${COMMON_DEPEND}
	x11-misc/xkeyboard-config"
DEPEND="${COMMON_DEPEND}
	x11-base/xorg-proto"
BDEPEND="virtual/pkgconfig
	doc? ( dev-util/gtk-doc )"

REQUIRED_USE="gles2? ( drm )"

PATCHES=( "${FILESDIR}"/kmscon-9.0.0-systemd-path-fix.patch )

src_prepare() {
	default
	export CC_FOR_BUILD="$(tc-getBUILD_CC)"
}

src_configure() {

	# kmscon sets -ffast-math unconditionally
	strip-flags

	local emesonargs=(
		$(meson_feature doc docs)
		$(meson_use debug)
		$(meson_feature systemd multi_seat)
		$(meson_feature fbdev video_fbdev)
		$(meson_feature drm video_drm2d)
		$(meson_feature drm video_drm3d)
		$(meson_feature unicode font_unifont)
		$(meson_feature pango font_pango)
		-Drenderer_bbulk=enabled
		$(meson_feature gles2 renderer_gltex)
		$(meson_feature pixman renderer_pixman)
		-Dsession_dummy=enabled
		-Dsession_terminal=enabled
	)

	meson_src_configure
}

pkg_postinst() {
	grep -e "^ERASECHAR" "${EROOT}"/etc/login.defs && \
	ewarn "It is recommended that you comment out the ERASECHAR line in" && \
	ewarn " /etc/login.defs for proper backspace functionality at the" && \
	ewarn " kmscon login prompt.  For details see:" && \
	ewarn "https://github.com/dvdhrm/kmscon/issues/69#issuecomment-13827797"
}
