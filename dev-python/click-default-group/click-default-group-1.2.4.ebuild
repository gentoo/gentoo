# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit-core
PYTHON_COMPAT=( python3_{12..15} )

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
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos"

RDEPEND="
	dev-python/click[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest
