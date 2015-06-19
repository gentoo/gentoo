# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-vcs/hg-fast-export/hg-fast-export-20140328.ebuild,v 1.3 2015/04/08 17:53:03 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit python-r1 vcs-snapshot

COMMIT="779e2f6da887729fc513f5efceaa3a3083858c9b"
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
	sed -e '/^PYTHON/s/python/&2/' \
		-e 's/PYTHON/E&/g' \
		-i "${PN}".sh || die
	rm Makefile || die #don't compile old svn2git code
}

src_install() {
	newbin "${PN}".sh "${PN}"
	python_foreach_impl python_doexe "${PN}".py
	python_foreach_impl python_domodule hg2git.py
}
