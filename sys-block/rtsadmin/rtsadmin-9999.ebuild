# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-block/rtsadmin/rtsadmin-9999.ebuild,v 1.1 2012/04/16 21:16:16 alexxy Exp $

EAPI=4

EGIT_REPO_URI="git://linux-iscsi.org/${PN}.git"
PYTHON_DEPEND="2"
RESTRICT_PYTHON_ABIS="3.*"
SUPPORT_PYTHON_ABIS="1"

inherit eutils distutils git-2 python linux-info

DESCRIPTION="RTSAdmin Community Edition for target_core_mod/ConfigFS"
HOMEPAGE="http://linux-iscsi.org/"
SRC_URI=""

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	dev-python/configshell
	dev-python/rtslib
	sys-block/lio-utils
	"
RDEPEND="${DEPEND}"

CONFIG_CHECK="~TARGET_CORE"

src_install() {
	distutils_src_install
	keepdir /var/target/
	keepdir /var/target/fabric
}
