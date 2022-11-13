# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

GH_TS="1668377184" # https://bugs.gentoo.org/881037 - bump this UNIX timestamp if the downloaded file changes checksum

DESCRIPTION="Fast NumPy array functions written in C"
HOMEPAGE="
	https://github.com/pydata/bottleneck/
	https://pypi.org/project/Bottleneck/
"
SRC_URI="
	https://github.com/pydata/bottleneck/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.gh@${GH_TS}.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ppc ppc64 ~riscv ~s390 ~sparc x86 ~amd64-linux ~x86-linux"

RDEPEND="
	>=dev-python/numpy-1.9.1[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
"

distutils_enable_tests pytest

python_test() {
	cd "${BUILD_DIR}/install$(python_get_sitedir)" || die
	epytest
}
