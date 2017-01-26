# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=(python{2_7,3_4})

inherit distutils-r1

MY_PN="${PN//retty-}"
DESCRIPTION="PyYAML-based module to produce pretty and readable YAML-serialized data"
HOMEPAGE="https://github.com/mk-fg/pretty-yaml"
SRC_URI="mirror://pypi/${PN:0:1}/${MY_PN}/${MY_PN}-${PV}.tar.gz"

LICENSE="WTFPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/unidecode[${PYTHON_USEDEP}] )"
RDEPEND="dev-python/pyyaml[${PYTHON_USEDEP}]"

S="${WORKDIR}/${MY_PN}-${PV}"

python_test() {
	"${PYTHON}" pyaml/tests/dump.py || die "tests failed under ${EPYTHON}"
}
