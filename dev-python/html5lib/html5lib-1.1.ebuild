# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..10} pypy3 )
PYTHON_REQ_USE="xml(+)"

inherit distutils-r1

DESCRIPTION="HTML parser based on the HTML5 specification"
HOMEPAGE="https://github.com/html5lib/html5lib-python/ https://html5lib.readthedocs.org"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-macos"

PATCHES=(
	"${FILESDIR}"/${P}-pytest6.patch
)

RDEPEND=">=dev-python/six-1.9[${PYTHON_USEDEP}]
	dev-python/webencodings[${PYTHON_USEDEP}]"
BDEPEND="
	test? (
		dev-python/pytest-expect[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
	)"

distutils_enable_tests pytest
