# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/configshell/configshell-9999.ebuild,v 1.3 2014/12/26 00:23:58 mgorny Exp $

EAPI=5

EGIT_REPO_URI="git://linux-iscsi.org/${PN}.git"
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 git-r3

DESCRIPTION="ConfigShell Community Edition for target_core_mod/ConfigFS"
HOMEPAGE="http://linux-iscsi.org/"
SRC_URI=""

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	dev-python/epydoc[${PYTHON_USEDEP}]
	dev-python/simpleparse[${PYTHON_USEDEP}]
	"
RDEPEND="${DEPEND}"
