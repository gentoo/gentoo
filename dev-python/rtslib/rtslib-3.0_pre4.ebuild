# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="RTSLib Community Edition for target_core_mod/ConfigFS"
HOMEPAGE="http://linux-iscsi.org/wiki/targetcli"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="git://github.com/Datera/${PN}.git
		https://github.com/Datera/${PN}.git"
	KEYWORDS=""
else
	MY_PV=${PV/_/-}
	SRC_URI="https://github.com/Datera/${PN}/archive/${PV/_/-}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-${MY_PV}"
	KEYWORDS="~amd64"
fi

DEPEND="dev-python/configobj[${PYTHON_USEDEP}]
	dev-python/ipaddr[${PYTHON_USEDEP}]
	dev-python/netifaces[${PYTHON_USEDEP}]
	dev-python/pyparsing[${PYTHON_USEDEP}]
	!dev-python/rtslib-fb"
RDEPEND="${DEPEND}"

src_install() {
	distutils-r1_src_install
	keepdir /var/target/fabric
	insinto /var/target/fabric
	doins specs/*.spec
}
