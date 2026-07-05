# Copyright 2023-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1 pypi

DESCRIPTION="Reusable constraint types to use with typing.Annotated"
HOMEPAGE="
	https://github.com/annotated-types/annotated-types/
	https://pypi.org/project/annotated-types/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"

EPYTEST_PLUGINS=( pytest-mock )
distutils_enable_tests pytest
