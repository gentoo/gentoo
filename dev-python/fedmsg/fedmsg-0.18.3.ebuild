# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_6 )
inherit distutils-r1

DESCRIPTION="Fedora Messaging Client API"
HOMEPAGE="http://www.fedmsg.com/ https://pypi.org/project/fedmsg/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

PATCHES=( "${FILESDIR}/0.18.0-endpoints.patch"
		  "${FILESDIR}/0.18.0-no_signatures.patch" )
RDEPEND="
	dev-python/pyzmq[${PYTHON_USEDEP}]
	dev-python/kitchen[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/arrow[${PYTHON_USEDEP}]
	dev-python/cryptography[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]
	$(python_gen_cond_dep 'dev-python/m2crypto[${PYTHON_USEDEP}]' 'python2*')
"
DEPEND="${RDEPEND}"
DOCS=(
	"README.rst" "CHANGELOG.rst"
	#TODO: doc/ dir full of rst files
)

python_install_all() {
	distutils-r1_python_install_all
	insinto /etc/
	doins -r "${S}/fedmsg.d"
}
