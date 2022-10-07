# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} pypy3 )

inherit distutils-r1 bash-completion-r1

MY_P=${P^}
DESCRIPTION="Pygments is a syntax highlighting package written in Python"
HOMEPAGE="
	https://pygments.org/
	https://github.com/pygments/pygments/
	https://pypi.org/project/Pygments/
"
SRC_URI="mirror://pypi/${MY_P:0:1}/${PN^}/${MY_P}.tar.gz"
S=${WORKDIR}/${MY_P}

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

BDEPEND="
	test? (
		dev-python/lxml[${PYTHON_USEDEP}]
		dev-python/pillow[${PYTHON_USEDEP}]
		dev-python/wcag-contrast-ratio[${PYTHON_USEDEP}]
		virtual/ttf-fonts
	)
"

distutils_enable_tests pytest

src_install() {
	distutils-r1_src_install
	newbashcomp external/pygments.bashcomp pygmentize
}
