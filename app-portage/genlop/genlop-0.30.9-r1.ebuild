# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit base bash-completion-r1

DESCRIPTION="A nice emerge.log parser"
HOMEPAGE="https://www.gentoo.org/proj/en/perl"
SRC_URI="mirror://gentoo//${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

DEPEND="dev-lang/perl
	 dev-perl/DateManip
	 dev-perl/libwww-perl"
RDEPEND="${DEPEND}"

# Populate the patches array for any patches for -rX releases
PATCHES=( "${FILESDIR}"/${P}-display.patch )

src_install() {
	dobin genlop || die "failed to install genlop (via dobin)"
	dodoc README Changelog
	doman genlop.1
	newbashcomp genlop.bash-completion genlop
}
