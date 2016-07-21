# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit distutils-r1

DESCRIPTION="Python bindings for Gammu"
HOMEPAGE="http://wammu.eu/python-gammu/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples test"

RDEPEND=">=app-mobilephone/gammu-1.34.0"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	test? (
		$(python_gen_impl_dep sqlite)
		app-mobilephone/gammu[dbi]
	)"

DOCS=( AUTHORS NEWS.rst README.rst )

python_test() {
	esetup.py test
}

python_install_all() {
	use examples && local EXAMPLES=( examples/. )
	distutils-r1_python_install_all
}
