# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="convert python profile data to kcachegrind calltree form"
HOMEPAGE="
	https://github.com/pwaller/pyprof2calltree/
	https://pypi.org/project/pyprof2calltree/
"
# pypi tarball lacks tests
SRC_URI="
	https://github.com/pwaller/pyprof2calltree/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

distutils_enable_tests unittest
