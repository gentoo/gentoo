# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="Apply JSON-Patches like http://tools.ietf.org/html/draft-pbryan-json-patch-04"
HOMEPAGE="https://github.com/stefankoegl/python-json-patch"
SRC_URI="https://github.com/stefankoegl/python-json-patch/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/python-json-patch-${PV}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm64 ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND=">=dev-python/jsonpointer-1.9[${PYTHON_USEDEP}]"
BDEPEND="
	test? ( ${RDEPEND} )
"
RESTRICT="!test? ( test )"

python_test() {
	"${EPYTHON}" tests.py || die "Tests of tests.py fail with ${EPYTHON}"
	"${EPYTHON}" ext_tests.py || die "Tests of ext_tests.py fail with ${EPYTHON}"
}
