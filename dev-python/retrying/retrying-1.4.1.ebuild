# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} pypy3_11 )

inherit distutils-r1

DESCRIPTION="General-purpose retrying library"
HOMEPAGE="
	https://github.com/groodt/retrying/
	https://pypi.org/project/retrying/
"
SRC_URI="
	https://github.com/groodt/retrying/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~m68k ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"

EPYTEST_PLUGINS=( pytest-rerunfailures )
distutils_enable_tests pytest

python_test() {
	# this package is very flaky
	epytest --reruns=10
}
