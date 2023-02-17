# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson-multilib

MY_PN="${PN/progs/demos}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Mesa's OpenGL utility and demo programs (glxgears and glxinfo)"
HOMEPAGE="https://www.mesa3d.org/ https://mesa.freedesktop.org/ https://gitlab.freedesktop.org/mesa/demos"
if [[ ${PV} = 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.freedesktop.org/mesa/demos.git"
else
	SRC_URI="https://mesa.freedesktop.org/archive/demos/${MY_P}.tar.bz2
		https://mesa.freedesktop.org/archive/demos/${PV}/${MY_P}.tar.bz2"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux"
	S="${WORKDIR}/${MY_P}"
fi
LICENSE="LGPL-2"
SLOT="0"
IUSE="gles2 wayland X"

RDEPEND="
	media-libs/mesa[${MULTILIB_USEDEP},egl(+),gles2?,wayland?,X?]
	wayland? ( dev-libs/wayland[${MULTILIB_USEDEP}] )
	X? (
		x11-libs/libX11[${MULTILIB_USEDEP}]
		x11-libs/libXext[${MULTILIB_USEDEP}]
	)
"
DEPEND="${RDEPEND}
	wayland? ( >=dev-libs/wayland-protocols-1.12 )
	X? ( x11-base/xorg-proto )
"
BDEPEND="
	virtual/pkgconfig
	wayland? ( dev-util/wayland-scanner )
"

PATCHES=(
	"${FILESDIR}"/9999-Disable-things-we-don-t-want.patch
)

pkg_setup() {
	MULTILIB_CHOST_TOOLS+=(
		/usr/bin/eglinfo
	)

	use X && MULTILIB_CHOST_TOOLS+=(
		/usr/bin/glxgears
		/usr/bin/glxinfo
	)

	use gles2 && use X && MULTILIB_CHOST_TOOLS+=(
		/usr/bin/es2_info
		/usr/bin/es2gears_x11
	)

	use gles2 && use wayland && MULTILIB_CHOST_TOOLS+=(
		/usr/bin/es2gears_wayland
	)
}

multilib_src_configure() {
	local emesonargs=(
		-Dlibdrm=disabled
		-Degl=enabled
		-Dgles1=disabled
		$(meson_feature gles2)
		-Dosmesa=disabled
		$(meson_feature wayland)
		$(meson_feature X x11)
	)
	meson_src_configure
}
