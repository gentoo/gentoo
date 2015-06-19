# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-portage/genlop/genlop-0.30.10-r1.ebuild,v 1.2 2015/03/03 05:53:40 dlan Exp $

EAPI=5

inherit base bash-completion-r1

DESCRIPTION="A nice emerge.log parser"
HOMEPAGE="http://www.gentoo.org/proj/en/perl"
SRC_URI="http://dev.gentoo.org/~dilfridge/distfiles/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

DEPEND="dev-lang/perl
	 dev-perl/DateManip
	 dev-perl/libwww-perl"
RDEPEND="${DEPEND}"

# Populate the patches array for any patches for -rX releases
PATCHES=( "${FILESDIR}"/${P}-sync.patch )

src_install() {
	dobin genlop
	dodoc README Changelog
	doman genlop.1
	newbashcomp genlop.bash-completion genlop
}
