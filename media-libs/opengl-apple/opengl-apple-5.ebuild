# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"

inherit prefix

DESCRIPTION="Links to Apple's OpenGL X11 implementation"
HOMEPAGE="http://www.apple.com/"
LICENSE="public-domain"
KEYWORDS="-* ~ppc-macos ~x64-macos ~x86-macos"
SLOT=0
IUSE=""

DEPEND=">=app-eselect/eselect-opengl-1.0.8-r1
	x11-proto/glproto"
RDEPEND="${DEPEND}"

X11_OPENGL_DIR="/usr/X11R6"

pkg_setup() {
	[[ ! -d ${X11_OPENGL_DIR} ]] && \
		die "${X11_OPENGL_DIR} not found, do you have X11/Xquartz installed?"
}

src_prepare() {
	cp "${FILESDIR}"/gl.pc .
	eprefixify gl.pc
}

src_install() {
	dodir /usr/lib/opengl/${PN}/{lib,include}
	dodir /usr/include/GL

	cd "${ED}"/usr/lib/opengl/${PN}/include || die
	ln -s "${X11_OPENGL_DIR}"/include/GL || die
	cd "${ED}"/usr/lib/opengl/${PN}/lib || die
	ln -s "${X11_OPENGL_DIR}"/lib/libGL.dylib || die

	cd "${ED}"/usr/include/GL || die
	ln -s "${X11_OPENGL_DIR}"/include/GL/glu.h || die
	ln -s "${X11_OPENGL_DIR}"/include/GL/GLwDrawA.h || die
	ln -s "${X11_OPENGL_DIR}"/include/GL/osmesa.h || die
	cd "${ED}"/usr/lib || die
	ln -s "${X11_OPENGL_DIR}"/lib/libGLU.dylib || die
	ln -s "${X11_OPENGL_DIR}"/lib/libGLw.a || die

	# bug #337965
	insinto /usr/lib/pkgconfig
	doins "${WORKDIR}"/gl.pc
}

pkg_postinst() {
	# Set as default VM if none exists
	eselect opengl set --use-old ${PN}

	elog "Note: you're using your OSX (pre-)installed OpenGL X11 implementation from ${X11_OPENGL_DIR}"
}
