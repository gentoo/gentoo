# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="A module for working with NMR data in Python"
HOMEPAGE="https://nmrglue.com/"
SRC_URI="https://github.com/jjhelmus/nmrglue/archive/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

# Requires sci-chemistry/nmrpipe from ::sci
RESTRICT="test"

RDEPEND="
	dev-python/matplotlib[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/scipy[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
BDEPEND="test? ( app-shells/tcsh )"

distutils_enable_tests nose
distutils_enable_sphinx doc/source dev-python/sphinx_rtd_theme dev-python/numpydoc
