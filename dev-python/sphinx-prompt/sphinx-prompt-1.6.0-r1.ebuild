# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( pypy3 python3_{9..11} )
inherit distutils-r1

DESCRIPTION="Sphinx directive to add unselectable prompt"
HOMEPAGE="https://github.com/sbrunner/sphinx-prompt/"
SRC_URI="https://github.com/sbrunner/${PN}/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

RDEPEND="
	dev-python/sphinx[${PYTHON_USEDEP}]
	dev-python/pygments[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

python_prepare_all() {
	# for Version: https://github.com/sbrunner/sphinx-prompt/pull/330
	# for Sphinx dep: https://github.com/sbrunner/sphinx-prompt/issues/174
	# and poetry-plugin-tweak-dependencies-version usage.
	sed -E -i \
		-e "/^version =/s:([0-9.]+):${PV}:" \
		-e "/^Sphinx =/s:([0-9.]+):>=5:" \
		pyproject.toml || die

	distutils-r1_python_prepare_all
}
