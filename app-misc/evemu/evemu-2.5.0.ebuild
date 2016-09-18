# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit eutils python-single-r1

DESCRIPTION="tools and bindings for kernel evdev device emulation, data capture, and replay"
HOMEPAGE="https://www.freedesktop.org/wiki/Evemu/"
SRC_URI="https://www.freedesktop.org/software/${PN}/${P}.tar.xz"

LICENSE="LGPL-3 GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="python static-libs"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="python? ( ${PYTHON_DEPS} )
	>=dev-libs/libevdev-1.2.99.902"
DEPEND="app-arch/xz-utils
	${RDEPEND}"

src_configure() {
	econf \
		$(use_enable static-libs static) \
		$(use_enable python python-bindings)
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

src_install() {
	default
	prune_libtool_files
}
