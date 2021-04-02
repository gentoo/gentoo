# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

MY_PN="${PN/progs/demos}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Mesa's OpenGL utility and demo programs (glxgears and glxinfo)"
HOMEPAGE="https://www.mesa3d.org/ https://mesa.freedesktop.org/ https://gitlab.freedesktop.org/mesa/demos"
if [[ ${PV} = 9999* ]]; then
	inherit autotools git-r3
	EGIT_REPO_URI="https://gitlab.freedesktop.org/mesa/demos.git"
	EGIT_CHECKOUT_DIR="${S}"
	EXPERIMENTAL="true"
else
	SRC_URI="https://mesa.freedesktop.org/archive/demos/${MY_P}.tar.bz2
		https://mesa.freedesktop.org/archive/demos/${PV}/${MY_P}.tar.bz2"
	KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ~mips ppc ppc64 sparc x86 ~amd64-linux ~x86-linux"
	S="${WORKDIR}/${MY_P}"
fi
LICENSE="LGPL-2"
SLOT="0"
IUSE="egl gles2"

RDEPEND="
	media-libs/mesa[egl?,gles2?]
	virtual/opengl
	x11-libs/libX11"
DEPEND="${RDEPEND}
	media-libs/glew
	virtual/glu
	x11-base/xorg-proto"

PATCHES=(
	"${FILESDIR}"/${P}-improve-printing.patch
)

src_prepare() {
	default
	[[ ${PV} = 9999* ]] && eautoreconf
}

src_compile() {
	emake -C src/xdemos glxgears glxinfo

	if use egl; then
		emake LDLIBS="-lEGL" -C src/egl/opengl/ eglinfo
		emake -C src/egl/eglut/ libeglut_x11.la
		emake LDLIBS="-lGL -lEGL -lX11 -lm" -C src/egl/opengl/ eglgears_x11

		if use gles2; then
			emake LDLIBS="-lGLESv2 -lEGL -lX11" -C src/egl/opengles2/ es2_info
			emake LDLIBS="-lGLESv2 -lEGL -lX11 -lm" -C src/egl/opengles2/ es2gears_x11
		fi
	fi
}

src_install() {
	dobin src/xdemos/{glxgears,glxinfo}
	if use egl; then
		dobin src/egl/opengl/egl{info,gears_x11}

		use gles2 && dobin src/egl/opengles2/es2{_info,gears_x11}
	fi
}
