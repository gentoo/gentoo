# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1

MY_P=diffx-pydiffx-release-${PV}
DESCRIPTION="Python module for reading and writing DiffX files"
HOMEPAGE="
	https://diffx.org/pydiffx/
	https://github.com/beanbaginc/diffx/
	https://pypi.org/project/pydiffx/
"
SRC_URI="
	https://github.com/beanbaginc/diffx/archive/pydiffx/release-${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}/python

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm64 x86"

RDEPEND="
	dev-python/six[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/kgb[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}"/${P}-fix-py3.12.patch
)

distutils_enable_tests unittest

src_prepare() {
	# remove .dev tag that breaks revdeps
	sed -e '/tag_build/d' -i setup.cfg || die
	distutils-r1_src_prepare
}
