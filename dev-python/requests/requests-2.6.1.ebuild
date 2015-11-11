# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{3,4} pypy pypy3 )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1

DESCRIPTION="HTTP library for human beings"
HOMEPAGE="http://python-requests.org/ https://pypi.python.org/pypi/requests"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE=""

# bundles dev-python/urllib3 snapshot
RDEPEND="
	app-misc/ca-certificates
	>=dev-python/chardet-2.2.1[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

# tests connect to various remote sites
RESTRICT="test"

PATCHES=(
	"${FILESDIR}"/${PN}-2.2.0-system-chardet.patch
	"${FILESDIR}"/${PN}-2.5.0-system-cacerts.patch
)

python_prepare_all() {
	# use system chardet
	rm -r requests/packages/chardet || die

	distutils-r1_python_prepare_all
}

python_test() {
	"${PYTHON}" test_requests.py || die "Tests fail with ${EPYTHON}"
}
