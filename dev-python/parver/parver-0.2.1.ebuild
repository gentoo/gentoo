# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7} )
inherit distutils-r1

DESCRIPTION="Parse and manipulate version numbers"
HOMEPAGE="https://github.com/RazerM/parver https://pypi.org/project/parver/"
SRC_URI="https://github.com/RazerM/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

PATCHES=(
	"${FILESDIR}"/${PN}-0.2.1-gentoo-versioning.patch
)

RDEPEND="
	>=dev-python/arpeggio-1.7[${PYTHON_USEDEP}]
	dev-python/attrs[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	"

DEPEND="
	test? (
		${RDEPEND}
		dev-python/hypothesis[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pretend[${PYTHON_USEDEP}]
	)"

python_test() {
	pytest -vv || die "Testing failed"
}
