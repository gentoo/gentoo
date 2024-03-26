# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools
export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}
inherit distutils-r1

DESCRIPTION="Source of XYZ tiles providers"
HOMEPAGE="https://github.com/geopandas/xyzservices"
SRC_URI="https://github.com/geopandas/${PN}/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="test"

BDEPEND="dev-python/setuptools-scm"

# Need mercantile module
# distutils_enable_tests pytest
