# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="ConfigShell Community Edition for target_core_mod/ConfigFS"
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
	SRC_URI="https://github.com/Datera/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

DEPEND="dev-python/epydoc[${PYTHON_USEDEP}]
	dev-python/pyparsing[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}
	dev-python/urwid[${PYTHON_USEDEP}]"
