# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/python-tvrage/python-tvrage-0.4.1.ebuild,v 1.4 2015/04/08 08:05:12 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 pypy )

inherit distutils-r1 vcs-snapshot

DESCRIPTION="Python client for the tvrage.com XML API"
HOMEPAGE="https://github.com/ckreutzer/python-tvrage"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/beautifulsoup:python-2[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

python_test() {
	"${PYTHON}" tests/api_tests.py || die "Testing failed with ${EPYTHON}"
}
