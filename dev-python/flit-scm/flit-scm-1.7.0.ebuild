# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=standalone
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )

inherit distutils-r1

MY_P=flit_scm-${PV}
DESCRIPTION="A PEP 518 build backend combining flit with setuptools_scm"
HOMEPAGE="
	https://gitlab.com/WillDaSilva/flit_scm/
	https://pypi.org/project/flit-scm/
"
SRC_URI="
	https://gitlab.com/WillDaSilva/flit_scm/-/archive/${PV}/${MY_P}.tar.bz2
"
S=${WORKDIR}/${MY_P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	>=dev-python/flit-core-3.5.0[${PYTHON_USEDEP}]
	>=dev-python/setuptools-scm-6.4.2[${PYTHON_USEDEP}]
"
BDEPEND="
	${RDEPEND}
"

src_prepare() {
	# unpin deps
	sed -i -e 's:~=[0-9.]*::' pyproject.toml || die
	distutils-r1_src_prepare
}

export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}
