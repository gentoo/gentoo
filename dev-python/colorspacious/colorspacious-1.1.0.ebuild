# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{6,7} )
inherit distutils-r1

DESCRIPTION="Powerful, accurate, and easy-to-use Python library for colorspace conversions"
HOMEPAGE="https://colorspacious.readthedocs.org/en/latest/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ppc64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	app-arch/unzip
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"

python_test () {
	nosetests --all-modules || die "Tests fail with ${EPYTHON}"
}
