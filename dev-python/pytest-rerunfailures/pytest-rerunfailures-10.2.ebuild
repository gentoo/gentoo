# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} pypy3 )
DISTUTILS_USE_SETUPTOOLS=rdepend
inherit distutils-r1

DESCRIPTION="pytest plugin to re-run tests to eliminate flaky failures"
HOMEPAGE="https://pypi.org/project/pytest-rerunfailures/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="MPL-2.0"
KEYWORDS="amd64 arm arm64 hppa ~ia64 ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"

BDEPEND="
	>=dev-python/pytest-5.0[${PYTHON_USEDEP}]
	test? ( !!dev-python/flaky )
"

distutils_enable_tests pytest
