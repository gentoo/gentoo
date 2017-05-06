# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} pypy )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1

DESCRIPTION="HTTP library for human beings"
HOMEPAGE="http://python-requests.org/ https://pypi.python.org/pypi/requests"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE="test"

RDEPEND="
	app-misc/ca-certificates
	>=dev-python/chardet-2.2.1[${PYTHON_USEDEP}]
	>=dev-python/cryptography-1.3.4[${PYTHON_USEDEP}]
	>=dev-python/idna-2.0[${PYTHON_USEDEP}]
	dev-python/ndg-httpsclient[${PYTHON_USEDEP}]
	>=dev-python/py-1.4.30[${PYTHON_USEDEP}]
	>=dev-python/pyopenssl-0.14[$(python_gen_usedep 'python*' pypy)]
	>=dev-python/urllib3-1.14[${PYTHON_USEDEP}]
	"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		>=dev-python/pytest-2.8.1[${PYTHON_USEDEP}]
	)
	"
#		>=dev-python/pytest-httpbin-0.0.7[${PYTHON_USEDEP}]

# tests connect to various remote sites
RESTRICT="test"

PATCHES=(
	"${FILESDIR}"/${PN}-2.12.1-system-packages.patch
	"${FILESDIR}"/${PN}-2.5.0-system-cacerts.patch
)

python_prepare_all() {
	# use system chardet & urllib3
	rm -r requests/packages/{chardet,urllib3} || die

	distutils-r1_python_prepare_all
}

python_test() {
	py.test -v || die
}
