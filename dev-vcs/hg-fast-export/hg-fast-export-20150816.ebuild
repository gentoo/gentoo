# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit python-r1 vcs-snapshot

COMMIT="3c27c693e13482059966003dd6545941b942a97a"
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
