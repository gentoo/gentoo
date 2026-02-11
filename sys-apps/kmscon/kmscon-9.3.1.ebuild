# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson flag-o-matic toolchain-funcs

DESCRIPTION="KMS/DRM based virtual Console Emulator"
HOMEPAGE="https://github.com/kmscon/kmscon"
SRC_URI="https://github.com/kmscon/kmscon/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT LGPL-2.1 BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="debug doc +drm elogind +fbdev +gles2 +pango systemd test"
RESTRICT="!test? ( test )"

COMMON_DEPEND="
	>=virtual/udev-172
	x11-libs/libxkbcommon
	>=dev-libs/libtsm-4.4.0:=
	media-libs/libglvnd[X(+)]
	drm? ( x11-libs/libdrm
		>=media-libs/mesa-8.0.3[egl(+),gbm(+)] )
	systemd? ( sys-apps/systemd )
	pango? ( x11-libs/pango dev-libs/glib:2 )"
RDEPEND="${COMMON_DEPEND}
	x11-misc/xkeyboard-config"
DEPEND="${COMMON_DEPEND}
	x11-base/xorg-proto"
BDEPEND="virtual/pkgconfig
	doc? ( dev-util/gtk-doc )"

REQUIRED_USE="
	drm? ( gles2 )
	?? ( elogind systemd )"

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
		-Dfont_unifont=enabled
		$(meson_feature pango font_pango)
		$(meson_feature gles2 renderer_gltex)
		$(meson_use test tests)
		-Dsession_dummy=enabled
		-Dsession_terminal=enabled
	)

	if use systemd; then
		emesonargs+=( -Dmulti_seat=enabled )
	elif use elogind; then
		emesonargs+=( -Dmulti_seat=enabled -Delogind=enabled )
	else
		emesonargs+=( -Dmulti_seat=disabled )
	fi

	meson_src_configure
}

pkg_postinst() {
	grep -e "^ERASECHAR" "${EROOT}"/etc/login.defs && \
	ewarn "It is recommended that you comment out the ERASECHAR line in" && \
	ewarn " /etc/login.defs for proper backspace functionality at the" && \
	ewarn " kmscon login prompt.  For details see:" && \
	ewarn "https://github.com/dvdhrm/kmscon/issues/69#issuecomment-13827797"
}
