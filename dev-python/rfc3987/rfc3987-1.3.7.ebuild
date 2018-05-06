# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{4,5,6} pypy pypy3 )

inherit distutils-r1

DESCRIPTION="Parsing and validation of URIs (RFC 3986) and IRIs (RFC 3987)"
HOMEPAGE="https://github.com/dgerber/rfc3987 https://pypi.org/project/rfc3987"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-fbsd ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="$(python_gen_cond_dep \
	'dev-python/regex[${PYTHON_USEDEP}]' python2_7 'python3*' pypy)"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
"

python_test() {
	${EPYTHON} -m doctest -v "${S}/${PN}.py" || die
}
