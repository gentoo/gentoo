# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( pypy3_11 python3_{11..14} python3_{13,14}t )

inherit distutils-r1 pypi

DESCRIPTION="Plugin to create 'gentoo' hypothesis profile, disabling health checks"
HOMEPAGE="
	https://github.com/projg2/hypothesis-gentoo/
	https://pypi.org/project/hypothesis-gentoo/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

# No RDEP on hypothesis -- it is only imported in the hypothesis hook

EPYTEST_PLUGINS=( hypothesis )
distutils_enable_tests pytest
