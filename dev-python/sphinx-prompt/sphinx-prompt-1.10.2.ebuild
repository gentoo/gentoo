# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1

DESCRIPTION="Sphinx directive to add unselectable prompt"
HOMEPAGE="
	https://github.com/sbrunner/sphinx-prompt/
	https://pypi.org/project/sphinx-prompt/
"
SRC_URI="
	https://github.com/sbrunner/sphinx-prompt/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~m68k ppc ppc64 ~riscv ~s390 ~sparc x86"

RDEPEND="
	dev-python/sphinx[${PYTHON_USEDEP}]
	dev-python/pygments[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

python_prepare_all() {
	# version number relies on git repo, sigh
	# also unpin dependencies
	# also hack to install as "sphinx-prompt"
	sed -i \
		-e "/^version =/s:[0-9.]\+:${PV}:" \
		-e '/include.*sphinx-prompt/d' \
		pyproject.toml || die

	distutils-r1_python_prepare_all
}
