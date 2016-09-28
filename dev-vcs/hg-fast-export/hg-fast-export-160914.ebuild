# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit python-r1 vcs-snapshot

DESCRIPTION="mercurial to git converter using git-fast-import"
HOMEPAGE="https://github.com/frej/fast-export"
SRC_URI="${HOMEPAGE}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

DEPEND=""
RDEPEND="dev-vcs/git
	dev-vcs/mercurial
	${PYTHON_DEPS}"

src_prepare() {
	default
	sed -e '/^PYTHON/s/python/&2.7/' \
		-e '/^PYTHON/s/PYTHON:/E&/g' \
		-e "/^ROOT/s:=.*:='${EPREFIX}/usr/bin':" \
		-i "${PN}".sh hg-reset.sh || die
}

src_install() {
	default
	newbin "${PN}".sh "${PN}"
	newbin hg-reset.sh hg-reset
	python_foreach_impl python_doexe "${PN}".py
	python_foreach_impl python_doexe hg-reset.py
	python_foreach_impl python_domodule hg2git.py
}
