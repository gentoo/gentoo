# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )
PYTHON_REQ_USE="threads(+)"
DISTUTILS_USE_SETUPTOOLS=rdepend
# entry_points is added via **kwargs in a dict
_DISTUTILS_SETUPTOOLS_WARNED=1

inherit distutils-r1 eutils

DESCRIPTION="Python code static checker"
HOMEPAGE="https://www.logilab.org/project/pylint
	https://pypi.org/project/pylint/
	https://github.com/pycqa/pylint"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~ia64 ~ppc ppc64 sparc x86"
IUSE="examples test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/astroid-2.3.3[${PYTHON_USEDEP}]
	>=dev-python/isort-4.2.5[${PYTHON_USEDEP}]
	dev-python/mccabe[${PYTHON_USEDEP}]"
BDEPEND="
	test? (
		${RDEPEND}
		dev-python/six[${PYTHON_USEDEP}]
	)"

PATCHES=(
	"${FILESDIR}/${PN}-2.4.4-sphinx-theme.patch"
	"${FILESDIR}/${PN}-2.4.4-no-pytest-runner.patch"
	"${FILESDIR}/${PN}-2.4.4-tests.patch"
)

distutils_enable_sphinx doc
distutils_enable_tests pytest

python_install_all() {
	doman man/{pylint,pyreverse}.1
	if use examples ; then
		docinto examples
		dodoc -r examples/.
	fi

	distutils-r1_python_install_all
}

pkg_postinst() {
	# Optional dependency on "tk" USE flag would break support for Jython.
	optfeature "pylint-gui script requires dev-lang/python with \"tk\" USE flag enabled." 'dev-lang/python[tk]'
}
