# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/ranger/ranger-9999.ebuild,v 1.8 2014/11/02 00:55:09 radhermit Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )
PYTHON_REQ_USE="ncurses"

inherit distutils-r1

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="git://git.savannah.nongnu.org/ranger.git"
	inherit git-r3
else
	SRC_URI="http://nongnu.org/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A vim-inspired file manager for the console"
HOMEPAGE="http://ranger.nongnu.org/"
LICENSE="GPL-3"
SLOT="0"

RDEPEND="virtual/pager"

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		elog "Ranger has many optional dependencies to support enhanced file previews."
		elog "See the README or homepage for more details."
	fi
}
