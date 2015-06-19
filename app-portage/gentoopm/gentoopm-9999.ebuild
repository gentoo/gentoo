# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-portage/gentoopm/gentoopm-9999.ebuild,v 1.14 2015/04/25 16:25:44 floppym Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy )

inherit distutils-r1

#if LIVE
EGIT_REPO_URI="git://anongit.gentoo.org/proj/${PN}.git
	http://anongit.gentoo.org/git/proj/${PN}.git
	http://bitbucket.org/mgorny/${PN}.git"
inherit git-r3
#endif

DESCRIPTION="A common interface to Gentoo package managers"
HOMEPAGE="https://bitbucket.org/mgorny/gentoopm/"
SRC_URI="https://www.bitbucket.org/mgorny/${PN}/downloads/${P}.tar.bz2"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~mips ~x86 ~amd64-fbsd ~x86-fbsd"
IUSE="doc"

RDEPEND="|| (
		sys-apps/pkgcore
		>=sys-apps/portage-2.1.10.3[${PYTHON_USEDEP}]
		>=sys-apps/paludis-0.64.2[python-bindings] )"
DEPEND="doc? ( dev-python/epydoc )"
PDEPEND="app-eselect/eselect-package-manager"

#if LIVE
KEYWORDS=
SRC_URI=
#endif

python_compile_all() {
	if use doc; then
		esetup.py doc
	fi
}

python_test() {
	esetup.py test
}

python_install_all() {
	use doc && local HTML_DOCS=( doc/. )

	distutils-r1_python_install_all
}
