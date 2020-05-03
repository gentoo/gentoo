# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8} )
inherit distutils-r1

DESCRIPTION="Standalone version of django.utils.feedgenerator"
HOMEPAGE="https://pypi.org/project/feedgenerator/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="test? ( dev-python/six[${PYTHON_USEDEP}]
		dev-python/pytz[${PYTHON_USEDEP}] )"
RDEPEND=""

distutils_enable_tests setup.py

src_prepare() {
	distutils-r1_src_prepare

	# Allow pypy to read MANIFEST.in
	ln -s tests_feedgenerator tests || die
}
