# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{10..12} pypy3 )

inherit distutils-r1

DESCRIPTION="Extends click.Group to invoke a command without explicit subcommand name"
HOMEPAGE="
	https://github.com/click-contrib/click-default-group/
	https://pypi.org/project/click-default-group/
"
SRC_URI="
	https://github.com/click-contrib/click-default-group/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos"

RDEPEND="
	dev-python/click[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
