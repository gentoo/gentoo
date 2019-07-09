# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{5,6} )
PYTHON_REQ_USE="xml(+)"

inherit distutils-r1 multilib prefix

DESCRIPTION="Collection of Gentoo-specific tools for Java"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Java"
SRC_URI="https://gitweb.gentoo.org/proj/${PN}.git/snapshot/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~sparc ~x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

python_prepare_all() {
	hprefixify src/py/buildparser src/py/findclass setup.py
	distutils-r1_python_prepare_all
}

python_install() {
	distutils-r1_python_install \
		--install-scripts="${EPREFIX}"/usr/$(get_libdir)/${PN}/bin
}
