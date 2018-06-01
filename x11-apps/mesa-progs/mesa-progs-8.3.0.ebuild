# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MY_PN=${PN/progs/demos}
MY_P=${MY_PN}-${PV}
EGIT_REPO_URI="https://anongit.freedesktop.org/git/mesa/demos.git"

if [[ ${PV} = 9999* ]]; then
	GIT_ECLASS="git-r3"
	EXPERIMENTAL="true"
fi

inherit base autotools toolchain-funcs ${GIT_ECLASS}

DESCRIPTION="Mesa's OpenGL utility and demo programs (glxgears and glxinfo)"
HOMEPAGE="https://www.mesa3d.org/ https://mesa.freedesktop.org/"
if [[ ${PV} == 9999* ]]; then
	SRC_URI=""
	KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sparc x86"
else
	SRC_URI="https://mesa.freedesktop.org/archive/demos/${PV}/${MY_P}.tar.bz2"
	KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 ~sh sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux"
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

S=${WORKDIR}/${MY_P}
EGIT_CHECKOUT_DIR=${S}

src_unpack() {
	default
	[[ $PV = 9999* ]] && git-r3_src_unpack
}

src_prepare() {
	base_src_prepare

	[[ $PV = 9999* ]] && eautoreconf
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
