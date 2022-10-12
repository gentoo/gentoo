# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1

DESCRIPTION="Relational programming in Python"
HOMEPAGE="
	https://pypi.org/project/miniKanren/
	https://github.com/pythological/kanren/
"
SRC_URI="
	https://github.com/pythological/kanren/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"
S="${WORKDIR}/kanren-${PV}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~riscv x86"

RDEPEND="
	dev-python/cons[${PYTHON_USEDEP}]
	dev-python/etuples[${PYTHON_USEDEP}]
	dev-python/logical-unification[${PYTHON_USEDEP}]
	dev-python/multipledispatch[${PYTHON_USEDEP}]
	dev-python/toolz[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
