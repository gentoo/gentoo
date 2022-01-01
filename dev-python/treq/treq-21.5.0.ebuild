# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="A requests-like API built on top of twisted.web's Agent"
HOMEPAGE="https://github.com/twisted/treq https://pypi.org/project/treq/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="doc test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/attrs[${PYTHON_USEDEP}]
	>=dev-python/hyperlink-21.0.0[${PYTHON_USEDEP}]
	dev-python/incremental[${PYTHON_USEDEP}]
	>=dev-python/requests-2.1.0[${PYTHON_USEDEP}]
	>=dev-python/twisted-18.7.0[crypt,${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/httpbin[${PYTHON_USEDEP}]
	)"

distutils_enable_sphinx docs

src_prepare() {
	# fix relative path for docs generation
	sed -e "s@('..')@('../src')@" -i docs/conf.py || die
	distutils-r1_src_prepare
}

python_test() {
	distutils_install_for_testing
	"${EPYTHON}" -m twisted.trial treq || die "Tests failed with ${EPYTHON}"
}
