# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( pypy3 python3_{7..9} )
PYTHON_REQ_USE="threads(+)"
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="Collection of tools for internationalizing Python applications"
HOMEPAGE="https://babel.pocoo.org/ https://pypi.org/project/Babel/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 ~riscv s390 sparc x86 ~x64-macos"

RDEPEND="dev-python/pytz[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		dev-python/backports-zoneinfo[${PYTHON_USEDEP}]
	' python3_{6..8} pypy3)"
DEPEND="${DEPEND}
	test? ( dev-python/freezegun[${PYTHON_USEDEP}] )"

distutils_enable_sphinx docs
distutils_enable_tests pytest

PATCHES=(
	"${FILESDIR}"/Babel-2.9.0-pypy3.patch
)

src_test() {
	local -x TZ=UTC
	distutils-r1_src_test
}
