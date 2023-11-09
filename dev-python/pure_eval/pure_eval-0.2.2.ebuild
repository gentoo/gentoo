# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )
inherit distutils-r1 pypi

DESCRIPTION="Safely evaluate AST nodes without side effects"
HOMEPAGE="https://github.com/alexmojaki/pure_eval"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ppc ppc64 ~riscv ~s390 sparc x86 ~arm64-macos ~x64-macos"

BDEPEND="dev-python/wheel[${PYTHON_USEDEP}]"

distutils_enable_tests pytest
