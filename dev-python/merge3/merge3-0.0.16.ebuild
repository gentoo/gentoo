# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Python implementation of 3-way merge"
HOMEPAGE="
	https://github.com/breezy-team/merge3
	https://pypi.org/project/merge3/
"
SRC_URI="
	https://github.com/breezy-team/merge3/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~loong ~ppc ~ppc64 ~riscv ~s390 x86"

distutils_enable_tests unittest
