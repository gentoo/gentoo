# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1

MY_P=Box-${PV}
DESCRIPTION="Python dictionaries with advanced dot notation access"
HOMEPAGE="
	https://github.com/cdgriffith/Box/
	https://pypi.org/project/python-box/
"
SRC_URI="
	https://github.com/cdgriffith/Box/archive/${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+native-extensions"

RDEPEND="
	dev-python/msgpack[${PYTHON_USEDEP}]
	dev-python/ruamel-yaml[${PYTHON_USEDEP}]
	dev-python/tomli-w[${PYTHON_USEDEP}]
"
BDEPEND="
	native-extensions? (
		dev-python/cython[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# require unpackaged 'toon' (probably from git too)
	test/test_box.py::TestBox::test_toon_files
	test/test_box.py::TestBox::test_toon_from_toon_with_box_args
	test/test_box.py::TestBox::test_toon_strings
	test/test_box_list.py::TestBoxList::test_toon_files
	test/test_box_list.py::TestBoxList::test_toon_strings
)

src_prepare() {
	if ! use native-extensions; then
		# a cheap hack, extensions are auto-disabled if Cython.Build
		# is not importable
		> Cython.py || die
	fi

	distutils-r1_src_prepare
}

python_test() {
	rm -rf box || die
	epytest
}
