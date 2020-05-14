# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python{3_6,3_7,3_8} pypy3 )

inherit distutils-r1

DESCRIPTION="Parse and generate Authentication-Results headers"
HOMEPAGE="https://launchpad.net/authentication-results-python
	https://pypi.org/project/authres/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
KEYWORDS="amd64 ~arm64 x86"
SLOT="0"
IUSE=""

python_test() {
	"${EPYTHON}" -m doctest -v authres/tests ||
		die "Tests fail with ${EPYTHON}"
}
