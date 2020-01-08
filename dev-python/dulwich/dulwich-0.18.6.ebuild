# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_6} )

inherit distutils-r1

DESCRIPTION="Pure-Python implementation of the Git file formats and protocols"
HOMEPAGE="https://github.com/jelmer/dulwich/ https://pypi.org/project/dulwich/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 arm64 ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="doc examples test"
RESTRICT="!test? ( test )"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/gevent[${PYTHON_USEDEP}]
		dev-python/geventhttpclient[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/python-fastimport[${PYTHON_USEDEP}]
	)"

DISTUTILS_IN_SOURCE_BUILD=1

# One test sometimes fails
# https://github.com/jelmer/dulwich/issues/541
PATCHES=( "${FILESDIR}/${PN}-0.18.3-skip-failing-test.patch" )

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	emake check
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/build/html/. )
	if use examples; then
		insinto "/usr/share/doc/${PF}"
		docompress -x "/usr/share/doc/${PF}/examples"
		doins -r examples
	fi
	distutils-r1_python_install_all
}
