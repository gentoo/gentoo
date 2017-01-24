# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit git-2 bash-completion-r1

EGIT_REPO_URI="git://github.com/gentoo-perl/genlop.git"
DESCRIPTION="A nice emerge.log parser"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Perl"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="dev-lang/perl
	 dev-perl/Date-Manip
	 dev-perl/libwww-perl"
RDEPEND="${DEPEND}"

src_install() {
	dobin genlop
	dodoc README Changelog
	doman genlop.1
	newbashcomp genlop.bash-completion genlop
}
