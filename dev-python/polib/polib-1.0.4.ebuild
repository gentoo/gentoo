# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/polib/polib-1.0.4.ebuild,v 1.6 2015/04/08 08:05:12 mgorny Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1

DESCRIPTION="A library to manipulate gettext files (.po and .mo files)"
HOMEPAGE="https://bitbucket.org/izi/polib/wiki/Home"
SRC_URI="https://www.bitbucket.org/izi/polib/downloads/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc"

RDEPEND=""
DEPEND="${RDEPEND}
	doc? ( dev-python/sphinx )
"

python_compile_all() {
	if use doc; then
		cd docs || die
		emake html
	fi
}

python_test() {
	python tests/tests.py || die
}

python_install_all() {
	local DOCS="CHANGELOG README.rst"
	use doc && local HTML_DOCS=( docs/_build/html/. )
	distutils-r1_python_install_all
}
