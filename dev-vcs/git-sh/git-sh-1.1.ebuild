# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-vcs/git-sh/git-sh-1.1.ebuild,v 1.3 2013/03/11 16:46:34 jlec Exp $

EAPI=4

inherit vcs-snapshot

DESCRIPTION="A customized bash environment suitable for git work"
HOMEPAGE="http://github.com/rtomayko/git-sh"
SRC_URI="http://github.com/rtomayko/${PN}/tarball/${PV} -> ${P}.tar.gz"

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
