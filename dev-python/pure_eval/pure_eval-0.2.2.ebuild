# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1

DESCRIPTION="Safely evaluate AST nodes without side effects"
HOMEPAGE="https://github.com/alexmojaki/pure_eval"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 hppa ~ia64 ppc ppc64 ~riscv ~s390 sparc x86"

BDEPEND="dev-python/wheel[${PYTHON_USEDEP}]"

distutils_enable_tests pytest
