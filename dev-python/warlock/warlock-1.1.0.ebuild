# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 python3_4 )

inherit distutils-r1

DESCRIPTION="Python object model built on JSON schema and JSON patch"
HOMEPAGE="https://github.com/bcwaldon/warlock"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86 ~amd64-linux ~x86-linux"
IUSE="test"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
		test? ( dev-python/six[${PYTHON_USEDEP}]
				>=dev-python/jsonpatch-0.10[${PYTHON_USEDEP}]
				<dev-python/jsonpatch-2[${PYTHON_USEDEP}]
				>=dev-python/jsonschema-0.7[${PYTHON_USEDEP}]
				<dev-python/jsonschema-3[${PYTHON_USEDEP}] )"
RDEPEND="dev-python/six[${PYTHON_USEDEP}]
		>=dev-python/jsonpatch-0.10[${PYTHON_USEDEP}]
		<dev-python/jsonpatch-2[${PYTHON_USEDEP}]
		>=dev-python/jsonschema-0.7[${PYTHON_USEDEP}]
		<dev-python/jsonschema-3[${PYTHON_USEDEP}]"

python_test() {
	"${PYTHON}" test/test_core.py || die
}
