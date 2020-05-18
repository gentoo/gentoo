# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8} )
DISTUTILS_USE_SETUPTOOLS=rdepend
inherit distutils-r1

DESCRIPTION="The BGP swiss army knife of networking"
HOMEPAGE="https://github.com/Exa-Networks/exabgp"
SRC_URI="https://github.com/Exa-Networks/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/ipaddr[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/psutil[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/six[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}/exabgp-4.2.7-paths.patch"
)

python_test() {
	./qa/bin/parsing || die "tests fail with ${EPYTHON}"
	nosetests -v ./qa/tests/*_test.py || die "tests fail with ${EPYTHON}"
}
