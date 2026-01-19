# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1

DESCRIPTION="A Python data validation library"
HOMEPAGE="
	https://github.com/alecthomas/voluptuous/
	https://pypi.org/project/voluptuous/
"
SRC_URI="
	https://github.com/alecthomas/voluptuous/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc x86"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest
