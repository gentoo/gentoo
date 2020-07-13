# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_{6,7,8} pypy3 )

inherit distutils-r1

DESCRIPTION="Python implementation of the markdown markup language"
HOMEPAGE="
	https://python-markdown.github.io/
	https://pypi.org/project/Markdown/
	https://github.com/Python-Markdown/markdown"
SRC_URI="mirror://pypi/M/${PN^}/${P^}.tar.gz"
S="${WORKDIR}/${P^}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 arm ~arm64 ~hppa ~ia64 ~mips ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="doc"

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/importlib_metadata[${PYTHON_USEDEP}]
	' python3_{6,7} pypy3)
"
BDEPEND="
	test? (
		dev-python/pygments[${PYTHON_USEDEP}]
		dev-python/pytidylib[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
	)"

distutils_enable_tests pytest

python_install_all() {
	use doc && dodoc -r docs/

	distutils-r1_python_install_all
}
