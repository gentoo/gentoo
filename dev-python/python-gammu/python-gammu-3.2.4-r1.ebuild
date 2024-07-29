# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1

DESCRIPTION="Python bindings for Gammu"
HOMEPAGE="
	https://wammu.eu/python-gammu/
	https://github.com/gammu/python-gammu/
	https://pypi.org/project/python-gammu/
"
SRC_URI="
	https://github.com/gammu/python-gammu/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples test"
RESTRICT="!test? ( test )"

DEPEND="
	>=app-mobilephone/gammu-1.34.0
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	virtual/pkgconfig
	test? (
		$(python_gen_impl_dep sqlite)
		app-mobilephone/gammu[dbi]
	)
"

DOCS=( AUTHORS NEWS.rst README.rst )

distutils_enable_tests unittest

python_test() {
	rm -rf gammu || die
	eunittest
}

python_install_all() {
	distutils-r1_python_install_all
	if use examples; then
		docompress -x /usr/share/doc/${P}/examples
		dodoc -r examples
	fi
}
