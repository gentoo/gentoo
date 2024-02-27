# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="Stylesheet Generator for PyQt5/PySide2"
HOMEPAGE="
	https://github.com/blambright/qstylizer/
	https://pypi.org/project/qstylizer/
"
SRC_URI="
	https://github.com/blambright/qstylizer/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	>=dev-python/tinycss2-0.5[${PYTHON_USEDEP}]
	<dev-python/tinycss2-2[${PYTHON_USEDEP}]
	>=dev-python/inflection-0.3.0[${PYTHON_USEDEP}]
	<dev-python/inflection-1[${PYTHON_USEDEP}]
"

BDEPEND="
	dev-python/pbr[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest-mock[${PYTHON_USEDEP}]
		dev-python/pytest-xdist[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
distutils_enable_sphinx doc \
	dev-python/sphinx-rtd-theme \
	dev-python/sphinxcontrib-autoprogram

python_prepare_all() {
	# fix test
	# https://github.com/blambright/qstylizer/pull/17
	sed -e 's:[.]called_once_with:.assert_called_once_with:' \
		-i test/unit/test_style.py || die

	distutils-r1_python_prepare_all

	export PBR_VERSION=${PV}
}
