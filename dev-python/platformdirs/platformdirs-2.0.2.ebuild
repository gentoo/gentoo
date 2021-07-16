# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} pypy3 )
inherit distutils-r1

DESCRIPTION="A small Python module for determining appropriate platform-specific dirs"
HOMEPAGE="
	https://pypi.org/project/platformdirs/
	https://github.com/platformdirs/platformdirs/"
SRC_URI="
	https://github.com/platformdirs/platformdirs/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="
	test? ( dev-python/appdirs[${PYTHON_USEDEP}] )"

distutils_enable_tests unittest
