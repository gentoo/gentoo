# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MY_PN=${PN/progs/demos}
MY_P=${MY_PN}-${PV}
EGIT_REPO_URI="git://anongit.freedesktop.org/${MY_PN/-//}"
EGIT_PROJECT="mesa-progs"

if [[ ${PV} = 9999* ]]; then
	GIT_ECLASS="git-2"
	EXPERIMENTAL="true"
fi

inherit base autotools toolchain-funcs ${GIT_ECLASS}

DESCRIPTION="Mesa's OpenGL utility and demo programs (glxgears and glxinfo)"
HOMEPAGE="http://mesa3d.sourceforge.net/"
if [[ ${PV} == 9999* ]]; then
	SRC_URI=""
else
	SRC_URI="ftp://ftp.freedesktop.org/pub/${MY_PN/-//}/${PV}/${MY_P}.tar.bz2"
fi

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~sh sparc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux"
IUSE="egl gles1 gles2"

COMMON_DEPEND="
	egl? ( media-libs/glew )
	gles1? ( media-libs/glew )
	gles2? ( media-libs/glew )
	media-libs/mesa[egl?,gles1?,gles2?]
	virtual/opengl
	x11-libs/libX11"
# glew and glu are only needed by the configure script when building.
# They are not actually required by the installed programs.
DEPEND="${COMMON_DEPEND}
	virtual/glu
	x11-proto/xproto"
# old gnash installs eglinfo too, bug #463654
RDEPEND="${COMMON_DEPEND}
	egl? ( !<=www-plugins/gnash-0.8.10_p20120903[egl] )"

S=${WORKDIR}/${MY_P}

src_unpack() {
	default
	[[ $PV = 9999* ]] && git-2_src_unpack
}

src_prepare() {
	base_src_prepare

	eautoreconf
}

src_configure() {
	# We're not using the complete buildsystem if we only want to build
	# glxinfo and glxgears.
	if use egl || use gles1 || use gles2; then
		default_src_configure
	fi
}

src_compile() {
	if ! use egl && ! use gles1 && ! use gles2; then
		tc-export CC
		emake LDLIBS='-lX11 -lGL' src/xdemos/glxinfo
		emake LDLIBS='-lX11 -lGL -lm' src/xdemos/glxgears
	else
		emake -C src/xdemos glxgears glxinfo
	fi

	if use egl; then
		emake LDLIBS="-lEGL" -C src/egl/opengl/ eglinfo
		emake -C src/egl/eglut/ libeglut_screen.la libeglut_x11.la
		emake LDLIBS="-lGL -lEGL -lX11 -lm" -C src/egl/opengl/ eglgears_x11
		emake LDLIBS="-lGL -lEGL -lm" -C src/egl/opengl/ eglgears_screen

		if use gles1; then
			emake LDLIBS="-lGLESv1_CM -lEGL -lX11" -C src/egl/opengles1/ es1_info
			emake LDLIBS="-lGLESv1_CM -lEGL -lX11 -lm" -C src/egl/opengles1/ gears_x11
			emake LDLIBS="-lGLESv1_CM -lEGL -lm" -C src/egl/opengles1/ gears_screen
		fi
		if use gles2; then
			emake LDLIBS="-lGLESv2 -lEGL -lX11" -C src/egl/opengles2/ es2_info
			emake LDLIBS="-lGLESv2 -lEGL -lX11 -lm" -C src/egl/opengles2/ es2gears_x11
			emake LDLIBS="-lGLESv2 -lEGL -lm" -C src/egl/opengles2/ es2gears_screen
		fi
	fi
}

src_install() {
	dobin src/xdemos/{glxgears,glxinfo}
	if use egl; then
		dobin src/egl/opengl/egl{info,gears_{screen,x11}}

		if use gles1; then
			dobin src/egl/opengles1/es1_info
			newbin src/egl/opengles1/gears_screen es1gears_screen
			newbin src/egl/opengles1/gears_x11 es1gears_x11
		fi

		use gles2 && dobin src/egl/opengles2/es2{_info,gears_{screen,x11}}
	fi
}
