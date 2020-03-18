# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7,8} pypy3 )

DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="Python implementation of the markdown markup language"
HOMEPAGE="
	https://python-markdown.github.io/
	https://pypi.org/project/Markdown/
	https://github.com/Python-Markdown/markdown"
SRC_URI="mirror://pypi/M/${PN^}/${P^}.tar.gz"

IUSE="doc"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"

DEPEND="test? (
	dev-python/pygments[${PYTHON_USEDEP}]
	dev-python/pytidylib[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}] )"

S="${WORKDIR}/${P^}"

distutils_enable_tests pytest

python_install_all() {
	use doc && dodoc -r docs/

	distutils-r1_python_install_all
}
