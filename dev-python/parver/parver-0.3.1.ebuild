# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
inherit distutils-r1

DESCRIPTION="Parse and manipulate version numbers"
HOMEPAGE="https://github.com/RazerM/parver https://pypi.org/project/parver/"
SRC_URI="https://github.com/RazerM/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"

RDEPEND="
	>=dev-python/arpeggio-1.7[${PYTHON_USEDEP}]
	>=dev-python/attrs-19.2[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	"

DEPEND="
	test? (
		${RDEPEND}
		dev-python/hypothesis[${PYTHON_USEDEP}]
		dev-python/pretend[${PYTHON_USEDEP}]
	)"

distutils_enable_tests pytest

src_prepare() {
	# unlock dependencies
	sed -i -e 's:~=:>=:g' setup.py || die

	distutils-r1_src_prepare
}
