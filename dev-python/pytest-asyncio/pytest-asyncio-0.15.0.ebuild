# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} pypy3 )

inherit distutils-r1

DESCRIPTION="Library for testing asyncio code with pytest"
HOMEPAGE="https://github.com/pytest-dev/pytest-asyncio
	https://pypi.org/project/pytest-asyncio/"
SRC_URI="https://github.com/pytest-dev/pytest-asyncio/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x64-macos"

RDEPEND="
	>=dev-python/pytest-5.4.0"
BDEPEND="
	test? (
		>=dev-python/hypothesis-3.64[${PYTHON_USEDEP}]
	)"

distutils_enable_tests --install pytest
