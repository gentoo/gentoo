# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/hatools/hatools-2.14.ebuild,v 1.4 2012/02/05 18:26:26 armin76 Exp $

EAPI=4

DESCRIPTION="High availability environment tools for shell scripting"
HOMEPAGE="http://www.fatalmind.com/software/hatools/"
SRC_URI="http://www.fatalmind.com/software/hatools/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~mips ~ppc x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris ~x86-solaris"
IUSE="test"

src_prepare() {
	sed 's:ksh:bash:g' -i test.sh || die
}
