# Copyright 2023-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..15} python3_{14..15}t )

inherit distutils-r1 pypi

DESCRIPTION="Expand system variables Unix style"
HOMEPAGE="
	https://github.com/sayanarijit/expandvars/
	https://pypi.org/project/expandvars/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

src_prepare() {
	# broken pytest config
	# https://github.com/sayanarijit/expandvars/commit/0ab5747185be9135b0711e72fc64dfa6a33f3fd3
	sed -i -e "/addopts = '/d" pyproject.toml || die

	distutils-r1_src_prepare
}
