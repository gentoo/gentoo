# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=bdepend
PYTHON_COMPAT=( python3_{7..9} pypy3 )

inherit distutils-r1

DESCRIPTION="a library for rendering \"readme\" descriptions for Warehouse"
HOMEPAGE="https://github.com/pypa/readme_renderer https://pypi.org/project/readme-renderer/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x64-macos"

RDEPEND="
	>=dev-python/bleach-2.1.0[${PYTHON_USEDEP}]
	>=dev-python/docutils-0.13.1[${PYTHON_USEDEP}]
	>=dev-python/pygments-2.5.2[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"
BDEPEND="
	test? ( dev-python/mock[${PYTHON_USEDEP}] )
"

DOCS=( README.rst )

distutils_enable_tests pytest
