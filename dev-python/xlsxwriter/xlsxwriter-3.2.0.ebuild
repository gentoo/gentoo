# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} pypy3 )

inherit distutils-r1

TAG=RELEASE_${PV}
MY_P=XlsxWriter-${TAG}
DESCRIPTION="Python module for creating Excel XLSX files"
HOMEPAGE="
	https://github.com/jmcnamara/XlsxWriter/
	https://pypi.org/project/XlsxWriter/
"
SRC_URI="
	https://github.com/jmcnamara/XlsxWriter/archive/${TAG}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

SLOT="0"
LICENSE="BSD"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"

distutils_enable_tests pytest

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest
}
