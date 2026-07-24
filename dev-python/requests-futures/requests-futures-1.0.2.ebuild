# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1 pypi

DESCRIPTION="Asynchronous Python HTTP for Humans"
HOMEPAGE="
	https://github.com/ross/requests-futures/
	https://pypi.org/project/requests-futures/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ~ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos"

RDEPEND="
	>=dev-python/requests-1.2.0[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=( pytest-httpbin )
distutils_enable_tests pytest
