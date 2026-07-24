# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1 pypi

DESCRIPTION="A decorator to automatically detect mismatch when overriding a method"
HOMEPAGE="
	https://pypi.org/project/overrides/
	https://github.com/mkorpela/overrides/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ~loong ppc ppc64 ~riscv ~s390 ~sparc x86"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

PATCHES=(
	# https://github.com/mkorpela/overrides/pull/133
	"${FILESDIR}/${P}-py314.patch"
)
