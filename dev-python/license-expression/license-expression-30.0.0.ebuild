# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{8..11} )

inherit distutils-r1

DESCRIPTION="Parse, compare, simplify and normalize license expressions"
HOMEPAGE="
	https://pypi.org/project/license-expression/
	https://github.com/nexB/license-expression/
"
SRC_URI="
	https://github.com/nexB/license-expression/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 ~riscv x86"

RDEPEND="
	>=dev-python/boolean-py-4.0[${PYTHON_USEDEP}]
"
BDEPEND="
	>=dev-python/setuptools_scm-4[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}
