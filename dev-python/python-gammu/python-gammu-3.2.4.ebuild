# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{9..10} )

inherit distutils-r1

DESCRIPTION="Python bindings for Gammu"
HOMEPAGE="https://wammu.eu/python-gammu/"
SRC_URI="https://github.com/gammu/python-gammu/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples test"
RESTRICT="!test? ( test )"

RDEPEND=">=app-mobilephone/gammu-1.34.0"
DEPEND="${RDEPEND}"
BDEPEND="
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
		docompress -x /usr/share/doc/${P}/examples
		dodoc -r examples
	fi
}
