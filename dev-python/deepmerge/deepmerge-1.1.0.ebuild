# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

DESCRIPTION="Tools to handle merging of nested data structures in python"
HOMEPAGE="
	https://deepmerge.readthedocs.io/en/latest/
	https://github.com/toumorokoshi/deepmerge/
	https://pypi.org/project/deepmerge/
"
SRC_URI="
	https://github.com/toumorokoshi/deepmerge/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

BDEPEND="
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}
