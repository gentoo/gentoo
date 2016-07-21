# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit vcs-snapshot

DESCRIPTION="A customized bash environment suitable for git work"
HOMEPAGE="https://github.com/rtomayko/git-sh"
SRC_URI="https://github.com/rtomayko/${PN}/tarball/${PV} -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="dev-vcs/git"

src_prepare() {
	sed \
		-e 's/git-completion\.bash //' \
		-e 's:/local::' -i Makefile || die "sed failed"
}

pkg_postinst() {
	echo
	einfo "For bash completion in git commands emerge dev-vcs/git"
	einfo "with bash-completion USE flag."
	echo
}
