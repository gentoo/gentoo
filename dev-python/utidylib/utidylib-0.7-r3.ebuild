# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )

MY_P="uTidylib-${PV}"
inherit distutils-r1

DESCRIPTION="TidyLib Python wrapper"
HOMEPAGE="https://cihar.com/software/utidylib/ https://pypi.org/project/uTidylib/"
SRC_URI="https://github.com/nijel/utidylib/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc ~ppc64 ~riscv ~x86"

RDEPEND=">=app-text/htmltidy-5.0.0"

distutils_enable_tests pytest
distutils_enable_sphinx docs

EPYTEST_DESELECT=(
	# https://github.com/nijel/utidylib/issues/9
	tidy/test_tidy.py::TidyTestCase::test_missing_load
)
