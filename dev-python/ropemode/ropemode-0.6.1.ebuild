# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

GH_TS="1668377184" # https://bugs.gentoo.org/881037 - bump this UNIX timestamp if the downloaded file changes checksum

DESCRIPTION="A helper for using rope refactoring library in IDEs"
HOMEPAGE="
	https://github.com/python-rope/ropemode/
	https://pypi.org/project/ropemode/
"
SRC_URI="
	https://github.com/python-rope/ropemode/archive/refs/tags/${PV}.tar.gz
		-> ${P}.gh@${GH_TS}.tar.gz
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/rope[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
