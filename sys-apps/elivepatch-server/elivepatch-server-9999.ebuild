# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_6} )

inherit distutils-r1

DESCRIPTION="Live patch building server with RESTFul Api for elivepatch-client"
HOMEPAGE="https://wiki.gentoo.org/wiki/Elivepatch"
if [[ ${PV} == *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/aliceinwire/elivepatch-server.git"
else
	SRC_URI="https://github.com/aliceinwire/elivepatch-server/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="GPL-2+"
SLOT="0"

RDEPEND="
	dev-python/werkzeug[${PYTHON_USEDEP}]
	dev-python/flask[${PYTHON_USEDEP}]
	dev-python/flask-restful[${PYTHON_USEDEP}]
	=sys-kernel/kpatch-9999"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

python_install_all() {
	newinitd init/elivepatch.init ${PN}
	newconfd init/elivepatch.confd ${PN}
	distutils-r1_python_install_all
}
