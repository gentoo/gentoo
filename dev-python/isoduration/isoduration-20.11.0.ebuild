# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} pypy3 )
inherit distutils-r1

DESCRIPTION="Operations with ISO 8601 durations"
HOMEPAGE="
	https://pypi.org/project/isoduration/
	https://github.com/bolsote/isoduration/"
SRC_URI="
	https://github.com/bolsote/isoduration/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND=">=dev-python/arrow-0.15.0[${PYTHON_USEDEP}]"
BDEPEND="
	test? (
		dev-python/hypothesis[${PYTHON_USEDEP}]
		dev-python/isodate[${PYTHON_USEDEP}]
	)"

distutils_enable_tests pytest

EPYTEST_IGNORE=(
	tests/test_benchmark.py
)
