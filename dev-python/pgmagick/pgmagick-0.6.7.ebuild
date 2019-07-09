# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{5,6} )

inherit distutils-r1

DESCRIPTION="Yet another boost.python based wrapper for GraphicsMagick"
HOMEPAGE="https://pypi.org/project/pgmagick/ https://bitbucket.org/hhatto/pgmagick/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	media-gfx/graphicsmagick:=[cxx]
	dev-libs/boost:=[python,${PYTHON_USEDEP}]"
DEPEND="
	${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( media-fonts/corefonts )"

python_test() {
	cd test || die

	local t
	for t in test_*.py; do
		"${EPYTHON}" "${t}" || die "test ${t} failed under ${EPYTHON}"
	done
	# As long as the order of python impls is not changed, this will suffice
}
