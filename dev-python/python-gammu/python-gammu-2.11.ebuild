# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_6} )

inherit distutils-r1

DESCRIPTION="Python bindings for Gammu"
HOMEPAGE="https://wammu.eu/python-gammu/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples test"
RESTRICT="!test? ( test )"

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
	distutils-r1_python_install_all
	if use examples; then
		docompress -x /usr/share/doc/${PF}/examples
		dodoc -r examples
	fi
}
