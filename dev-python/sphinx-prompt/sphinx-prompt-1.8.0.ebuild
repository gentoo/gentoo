# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( pypy3 python3_{10..13} )

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
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	dev-python/sphinx[${PYTHON_USEDEP}]
	dev-python/pygments[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

python_prepare_all() {
	# version number relies on git repo, sigh
	# also all dependencies are pinned to exact versions, sigh
	# also huge hack to install package as "sphinx-prompt", sigh
	sed -i \
		-e "/^version =/s:[0-9.]\+:${PV}:" \
		-e '/^\[tool\.poetry\.dependencies\]$/,$s:"[0-9.]\+:"*:' \
		-e '/include.*sphinx-prompt/d' \
		pyproject.toml || die

	distutils-r1_python_prepare_all
}
