# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-vcs/hg-fast-export/hg-fast-export-20140706.ebuild,v 1.2 2014/09/11 17:40:50 ottxor Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit python-r1 vcs-snapshot

COMMIT="2c21922ad1795e1d305dac6bdb977f2e50eb809e"
DESCRIPTION="mercurial to git converter using git-fast-import"
HOMEPAGE="https://github.com/frej/fast-export"
SRC_URI="${HOMEPAGE}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm"
IUSE=""

DEPEND=""
RDEPEND="dev-vcs/git
	dev-vcs/mercurial
	${PYTHON_DEPS}"

src_prepare() {
	sed -e '/^PYTHON/s/python/&2.7/' \
		-e '/^PYTHON/s/PYTHON:/E&/g' \
		-e "/^ROOT/s:=.*:='${EPREFIX}/usr/bin':" \
		-i "${PN}".sh || die
	rm Makefile || die #don't compile old svn2git code
}

src_install() {
	newbin "${PN}".sh "${PN}"
	dodoc README
	python_foreach_impl python_doexe "${PN}".py
	python_foreach_impl python_domodule hg2git.py
}
