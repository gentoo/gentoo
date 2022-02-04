# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} pypy3 )
inherit distutils-r1

DESCRIPTION="Server to test HTTP clients"
HOMEPAGE="https://github.com/lorien/test_server https://pypi.org/project/test-server/"
SRC_URI="https://github.com/lorien/test_server/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-python/bottle-0.12.13[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/webtest[${PYTHON_USEDEP}]"

PATCHES=(
	"${FILESDIR}/${P}-fix-py3.10.patch"
)

distutils_enable_tests pytest
