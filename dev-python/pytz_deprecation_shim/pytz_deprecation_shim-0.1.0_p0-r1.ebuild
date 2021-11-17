# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
DISTUTILS_USE_SETUPTOOLS=pyproject.toml
inherit distutils-r1

MY_P=${P/_p/.post}

DESCRIPTION="Shims to make deprecation of pytz easier"
HOMEPAGE="https://pypi.org/project/pytz-deprecation-shim/ https://github.com/pganssle/pytz-deprecation-shim"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/backports-zoneinfo[${PYTHON_USEDEP}]
	' python3_8 pypy3)
	sys-libs/timezone-data
"
BDEPEND="
	test? (
		dev-python/hypothesis[${PYTHON_USEDEP}]
		dev-python/pytz[${PYTHON_USEDEP}]
		dev-python/toml[${PYTHON_USEDEP}]
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
