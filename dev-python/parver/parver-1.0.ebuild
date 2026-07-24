# Copyright 2019-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1

DESCRIPTION="Parse and manipulate version numbers"
HOMEPAGE="
	https://github.com/RazerM/parver/
	https://pypi.org/project/parver/
"
SRC_URI="
	https://github.com/RazerM/parver/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm64 ~riscv x86"

BDEPEND="
	test? (
		dev-python/pretend[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=( hypothesis )
distutils_enable_tests pytest

python_test() {
	epytest -o addopts=
}
