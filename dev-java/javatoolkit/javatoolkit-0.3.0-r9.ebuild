# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PYTHON_COMPAT=(python2_7)
PYTHON_REQ_USE="xml(+)"

inherit distutils-r1 eutils multilib prefix

DESCRIPTION="Collection of Gentoo-specific tools for Java"
HOMEPAGE="https://www.gentoo.org/proj/en/java/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ppc64 sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

python_prepare_all() {
	local PATCHES=(
		"${FILESDIR}/${P}-python2.6.patch"
		"${FILESDIR}/${P}-no-pyxml.patch"
	)
	hprefixify setup.py

	distutils-r1_python_prepare_all
}

python_install() {
	distutils-r1_python_install \
		--install-scripts="${EPREFIX}"/usr/$(get_libdir)/${PN}/bin
}
