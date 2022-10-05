# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson-multilib optfeature

DESCRIPTION="Video Acceleration (VA) API for Linux"
HOMEPAGE="https://01.org/linuxmedia/vaapi"

if [[ ${PV} = *9999 ]] ; then
	inherit git-r3
	EGIT_BRANCH=master
	EGIT_REPO_URI="https://github.com/intel/libva"
else
	SRC_URI="https://github.com/intel/libva/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 arm64 ~loong ~ppc64 ~riscv x86 ~amd64-linux ~x86-linux"
fi

LICENSE="MIT"
SLOT="0/$(ver_cut 1)"
IUSE="+drm opengl wayland X"
REQUIRED_USE="opengl? ( X )"

RDEPEND="
	>=x11-libs/libdrm-2.4.60[${MULTILIB_USEDEP}]
	wayland? (
		>=dev-libs/wayland-1.11[${MULTILIB_USEDEP}]
	)
	X? (
		>=virtual/opengl-7.0-r1[${MULTILIB_USEDEP}]
		>=x11-libs/libX11-1.6.2[${MULTILIB_USEDEP}]
		>=x11-libs/libXext-1.3.2[${MULTILIB_USEDEP}]
		>=x11-libs/libXfixes-5.0.1[${MULTILIB_USEDEP}]
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	wayland? ( dev-util/wayland-scanner )
	virtual/pkgconfig
"

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/va/va_backend_glx.h
	/usr/include/va/va_x11.h
	/usr/include/va/va_dri2.h
	/usr/include/va/va_dricommon.h
	/usr/include/va/va_glx.h
)

multilib_src_configure() {
	local emesonargs=(
		-Ddriverdir="${EPREFIX}/usr/$(get_libdir)/va/drivers"
		-Ddisable_drm=false
		-Dwith_x11=$(usex X)
		-Dwith_glx=$(usex X)
		-Dwith_wayland=$(usex wayland)
		-Denable_docs=false
		-Denable_va_messaging=true
	)
	meson_src_configure
}

pkg_postinst() {
	optfeature_header
	optfeature "Older Intel GPU support" x11-libs/libva-intel-driver
	optfeature "Newer Intel GPU support" x11-libs/libva-intel-media-driver
}
