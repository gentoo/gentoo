# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3 bash-completion-r1

EGIT_REPO_URI="https://github.com/gentoo-perl/genlop.git"
DESCRIPTION="A nice emerge.log parser"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Perl"

LICENSE="GPL-2"
SLOT="0"

DEPEND="
	dev-lang/perl
	dev-perl/Date-Manip
	dev-perl/libwww-perl"
RDEPEND="${DEPEND}"

src_install() {
	dobin genlop
	dodoc README Changelog
	doman genlop.1
	newbashcomp genlop.bash-completion genlop
}
