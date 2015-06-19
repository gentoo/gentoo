# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/raspberrypi-userland/raspberrypi-userland-9999.ebuild,v 1.3 2015/03/17 13:03:30 tupone Exp $

EAPI=5
inherit cmake-utils git-r3

DESCRIPTION="Raspberry Pi userspace tools and libraries"
HOMEPAGE="https://github.com/raspberrypi/userland"
SRC_URI=""

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND=""

EGIT_REPO_URI="https://github.com/raspberrypi/userland"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gentoo.patch
}

src_install() {
	cmake-utils_src_install

	dodir /usr/lib/opengl/raspberrypi/lib
	touch "${D}"/usr/lib/opengl/raspberrypi/.gles-only
	mv "${D}"/usr/lib/lib{EGL,GLESv2}* \
		"${D}"/usr/lib/opengl/raspberrypi/lib

	dodir /usr/lib/opengl/raspberrypi/include
	mv "${D}"/usr/include/{EGL,GLES,GLES2,KHR,WF} \
		"${D}"/usr/lib/opengl/raspberrypi/include
	mv "${D}"/usr/include/interface/vcos/pthreads/* \
		"${D}"/usr/include/interface/vcos/
	rmdir "${D}"/usr/include/interface/vcos/pthreads
	mv "${D}"/usr/include/interface/vmcs_host/linux/* \
		"${D}"/usr/include/interface/vmcs_host/
	rmdir "${D}"/usr/include/interface/vmcs_host/linux

	dodir /usr/share/doc/${PF}
	mv "${D}"/usr/src/hello_pi "${D}"/usr/share/doc/${PF}/
	rmdir "${D}"/usr/src
}
