# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )
AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_IN_SOURCE_BUILD=1

inherit autotools-utils python-single-r1

DESCRIPTION="Tools and bindings for kernel input event device emulation, data capture, and replay"
HOMEPAGE="http://www.freedesktop.org/wiki/Evemu/"
SRC_URI="http://www.freedesktop.org/software/${PN}/${P}.tar.xz"

LICENSE="LGPL-3 GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="python static-libs"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="python? ( ${PYTHON_DEPS} )
	>=dev-libs/libevdev-1.2.99.902"
DEPEND="app-arch/xz-utils
	${RDEPEND}"

PATCHES=( "${FILESDIR}"/${PN}-1.2.0-install-man.patch )

src_prepare() {
	if ! use python ; then
		sed '/SUBDIRS/s/python//' -i Makefile.am || die
	fi
	autotools-utils_src_prepare
}

src_test() {
	if use python ; then
		if [[ ! ${EUID} -eq 0 ]] || has sandbox $FEATURES || has usersandbox $FEATURES ; then
			ewarn "Tests require userpriv, sandbox, and usersandbox to be disabled in FEATURES."
		else
			emake check
		fi
	fi
}
