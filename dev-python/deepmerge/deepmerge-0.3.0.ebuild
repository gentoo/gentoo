# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
inherit distutils-r1

DESCRIPTION="Tools to handle merging of nested data structures in python"
HOMEPAGE="https://deepmerge.readthedocs.io/en/latest"
SRC_URI="
	https://github.com/toumorokoshi/deepmerge/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="
	dev-python/setuptools_scm[${PYTHON_USEDEP}]"

distutils_enable_tests pytest

export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}
