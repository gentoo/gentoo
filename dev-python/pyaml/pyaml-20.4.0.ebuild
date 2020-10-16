# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )
inherit distutils-r1

DESCRIPTION="pretty and readable YAML-serialized data generator"
HOMEPAGE="https://github.com/mk-fg/pretty-yaml"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/unidecode[${PYTHON_USEDEP}]
"

python_test() {
	${EPYTHON} pyaml/tests/dump.py || die "tests failed with ${EPYTHON}"
}
