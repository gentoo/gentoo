# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/hexedit/hexedit-1.2.13.ebuild,v 1.11 2013/07/02 07:44:04 ago Exp $

DESCRIPTION="View and edit files in hex or ASCII"
HOMEPAGE="http://rigaux.org/hexedit.html"
SRC_URI="http://rigaux.org/${P}.src.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ~mips ppc ppc64 s390 sh sparc x86 ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE=""

DEPEND="sys-libs/ncurses"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

src_install() {
	dobin hexedit || die "dobin failed"
	doman hexedit.1
	dodoc Changes
}
