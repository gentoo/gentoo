# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 python3_{6,7} )

inherit distutils-r1

DESCRIPTION="A simple serialization library based on ast.literal_eval"
HOMEPAGE="https://pypi.org/project/serpent/ https://github.com/irmen/Serpent"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm64 ppc ppc64 x86"
IUSE=""

# not bundled
RESTRICT="test"

python_test() {
	pushd "${S}"/tests >/dev/null || die
	${PYTHON} -bb test_serpent.py || die
	popd >/dev/null || die
}
