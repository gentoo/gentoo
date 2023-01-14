# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} pypy3 )

inherit distutils-r1

MY_P=${P^}
DESCRIPTION="Python implementation of the markdown markup language"
HOMEPAGE="
	https://python-markdown.github.io/
	https://pypi.org/project/Markdown/
	https://github.com/Python-Markdown/markdown/
"
SRC_URI="mirror://pypi/${MY_P::1}/${PN^}/${MY_P}.tar.gz"
S=${WORKDIR}/${MY_P}

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="doc"

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/importlib_metadata[${PYTHON_USEDEP}]
	' 3.8 3.9)
"
BDEPEND="
	test? (
		dev-python/pygments[${PYTHON_USEDEP}]
		dev-python/pytidylib[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests unittest

python_install_all() {
	use doc && dodoc -r docs/

	distutils-r1_python_install_all
}
