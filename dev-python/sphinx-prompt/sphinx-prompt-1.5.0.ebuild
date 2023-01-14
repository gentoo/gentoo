# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( pypy3 python3_{9..10} )
inherit distutils-r1

DESCRIPTION="Sphinx directive to add unselectable prompt"
HOMEPAGE="https://github.com/sbrunner/sphinx-prompt/"
SRC_URI="https://github.com/sbrunner/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	dev-python/sphinx[${PYTHON_USEDEP}]
	dev-python/pygments[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
