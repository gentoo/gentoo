# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

EGIT_REPO_URI="git://linux-iscsi.org/${PN}.git"
PYTHON_DEPEND="2"
RESTRICT_PYTHON_ABIS="3.*"
SUPPORT_PYTHON_ABIS="1"

inherit eutils distutils git-2 python linux-info

DESCRIPTION="The targetcli administration shell"
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

pkg_setup() {
	linux-info_pkg_setup
	python_pkg_setup
}
