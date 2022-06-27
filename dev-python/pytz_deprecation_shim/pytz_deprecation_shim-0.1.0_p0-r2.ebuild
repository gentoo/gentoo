# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} pypy3 )

inherit distutils-r1

MY_P=${P/_p/.post}

DESCRIPTION="Shims to make deprecation of pytz easier"
HOMEPAGE="
	https://github.com/pganssle/pytz-deprecation-shim/
	https://pypi.org/project/pytz-deprecation-shim/
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${MY_P}.tar.gz"
S=${WORKDIR}/${MY_P}

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc x86"

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/backports-zoneinfo[${PYTHON_USEDEP}]
	' 3.8)
	sys-libs/timezone-data
"
BDEPEND="
	test? (
		dev-python/hypothesis[${PYTHON_USEDEP}]
		dev-python/pytz[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
distutils_enable_sphinx docs \
	dev-python/sphinx_rtd_theme

src_prepare() {
	# apparently used only as a fallback
	sed -i -e '/tzdata/d' setup.cfg || die
	distutils-r1_src_prepare
}
