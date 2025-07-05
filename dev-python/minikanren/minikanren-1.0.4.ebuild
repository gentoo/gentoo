# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..13} )

inherit distutils-r1

MY_P=kanren-${PV}
DESCRIPTION="Relational programming in Python"
HOMEPAGE="
	https://pypi.org/project/miniKanren/
	https://github.com/pythological/kanren/
"
SRC_URI="
	https://github.com/pythological/kanren/archive/v${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~loong ~riscv x86"

RDEPEND="
	>=dev-python/cons-0.4.0[${PYTHON_USEDEP}]
	>=dev-python/etuples-0.3.1[${PYTHON_USEDEP}]
	>=dev-python/logical-unification-0.4.1[${PYTHON_USEDEP}]
	dev-python/multipledispatch[${PYTHON_USEDEP}]
	dev-python/toolz[${PYTHON_USEDEP}]
	dev-python/typing-extensions[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}
