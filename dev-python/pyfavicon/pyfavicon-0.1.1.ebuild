# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="Async favicon fetcher"
HOMEPAGE="https://github.com/bilelmoussaoui/pyfavicon"
SRC_URI="https://github.com/bilelmoussaoui/pyfavicon/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RESTRICT="!test? ( test )"

RDEPEND="${PYTHON_DEPS}
	dev-python/aiohttp[${PYTHON_USEDEP}]
	dev-python/beautifulsoup:4[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/yarl[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"

# fix tests: network is required
PATCHES=( "${FILESDIR}/${P}_fix_tests.patch" )

distutils_enable_tests pytest
