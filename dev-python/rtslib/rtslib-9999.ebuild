# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

EGIT_REPO_URI="git://linux-iscsi.org/${PN}.git"
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 git-2

DESCRIPTION="RTSLib Community Edition for target_core_mod/ConfigFS"
HOMEPAGE="http://linux-iscsi.org/"
SRC_URI=""

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	dev-python/configobj[${PYTHON_USEDEP}]
	dev-python/ipaddr[${PYTHON_USEDEP}]
	dev-python/netifaces[${PYTHON_USEDEP}]
	!dev-python/rtslib-fb[${PYTHON_USEDEP}]
	"
RDEPEND="${DEPEND}"

src_install() {
	distutils-r1_src_install
	keepdir /var/target/fabric
	insinto /var/target/fabric
	doins specs/*.spec
}
