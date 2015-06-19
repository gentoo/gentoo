# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-eselect/eselect-opengl/eselect-opengl-1.2.7.ebuild,v 1.2 2015/06/17 12:28:01 chithanh Exp $

EAPI=4

inherit multilib

DESCRIPTION="Utility to change the OpenGL interface being used"
HOMEPAGE="http://www.gentoo.org/"

# Source:
# http://www.opengl.org/registry/api/glext.h
# http://www.opengl.org/registry/api/glxext.h
GLEXT="85"
GLXEXT="34"

MIRROR="http://dev.gentoo.org/~mattst88/distfiles"
SRC_URI="${MIRROR}/glext.h.${GLEXT}.xz
	${MIRROR}/glxext.h.${GLXEXT}.xz
	${MIRROR}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""

DEPEND="app-arch/xz-utils"
RDEPEND=">=app-admin/eselect-1.2.4
		 !<media-libs/mesa-8.0.3-r1
		 !<x11-proto/glproto-1.4.15-r1
		 !=media-libs/mesa-10.3.4-r1
		 !=media-libs/mesa-10.3.5-r1
		 !>=media-libs/mesa-10.3.7-r2
		 !>=x11-proto/glproto-1.4.17-r1
		 !=x11-base/xorg-server-1.16.4-r1
		 !>=x11-base/xorg-server-1.16.4-r4"

pkg_postinst() {
	local impl="$(eselect opengl show)"
	if [[ -n "${impl}"  && "${impl}" != '(none)' ]] ; then
		eselect opengl set "${impl}"
	fi
}

src_prepare() {
	# don't die on Darwin users
	if [[ ${CHOST} == *-darwin* ]] ; then
		sed -i -e 's/libGL\.so/libGL.dylib/' opengl.eselect || die
	fi
}

src_install() {
	insinto "/usr/share/eselect/modules"
	doins opengl.eselect
	doman opengl.eselect.5

	# Install global glext.h and glxext.h
	insinto "/usr/$(get_libdir)/opengl/global/include/GL/"
	cd "${WORKDIR}"
	newins glext.h.${GLEXT} glext.h
	newins glxext.h.${GLXEXT} glxext.h
}
