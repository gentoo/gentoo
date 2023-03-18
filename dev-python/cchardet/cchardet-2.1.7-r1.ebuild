# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )
inherit distutils-r1 pypi

DESCRIPTION="High speed universal character encoding detector"
HOMEPAGE="
	https://github.com/PyYoshi/cChardet
	https://pypi.org/project/cchardet/
"

LICENSE="MPL-1.1"
SLOT="0"
KEYWORDS="amd64 ~arm ~x86"

BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
"

PATCHES=(
	# https://github.com/PyYoshi/cChardet/pull/78
	"${FILESDIR}/${P}-pytest.patch"
)

distutils_enable_tests pytest
