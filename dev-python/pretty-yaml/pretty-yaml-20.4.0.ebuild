# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6..9} )

inherit distutils-r1

MY_P=pyaml-${PV}
DESCRIPTION="PyYAML-based module to produce pretty and readable YAML-serialized data"
HOMEPAGE="https://github.com/mk-fg/pretty-yaml"
SRC_URI="mirror://pypi/${PN:0:1}/${MY_P%-*}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="WTFPL-2"
SLOT="0"
KEYWORDS="~amd64 arm ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-python/pyyaml[${PYTHON_USEDEP}]"
BDEPEND="
	test? (
		${RDEPEND}
		dev-python/unidecode[${PYTHON_USEDEP}]
	)"

python_test() {
	"${EPYTHON}" pyaml/tests/dump.py -v ||
		die "tests failed under ${EPYTHON}"
}
