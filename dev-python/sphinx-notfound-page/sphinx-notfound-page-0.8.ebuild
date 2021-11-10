# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( pypy3 python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Create a custom 404 page with absolute URLs hardcoded."
HOMEPAGE="https://sphinx-notfound-page.readthedocs.io/"
# PyPI tarballs lack tests
# https://github.com/readthedocs/sphinx-notfound-page/pull/110
SRC_URI="
	https://github.com/readthedocs/sphinx-notfound-page/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86 ~x64-macos"

RDEPEND="dev-python/sphinx[${PYTHON_USEDEP}]"

distutils_enable_tests pytest
