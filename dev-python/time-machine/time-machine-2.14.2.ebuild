# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1

DESCRIPTION="Travel through time in your tests"
HOMEPAGE="
	https://github.com/adamchainz/time-machine/
	https://pypi.org/project/time-machine/
"
SRC_URI="
	https://github.com/adamchainz/time-machine/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	dev-python/python-dateutil[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
