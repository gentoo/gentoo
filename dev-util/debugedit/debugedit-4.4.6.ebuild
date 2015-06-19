# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/debugedit/debugedit-4.4.6.ebuild,v 1.5 2006/10/03 21:40:38 wolf31o2 Exp $

inherit toolchain-funcs

DESCRIPTION="Standalone debugedit taken from rpm"

HOMEPAGE="http://www.rpm.org/"
SRC_URI="http://dev.gentoo.org/~tester/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE=""

DEPEND="dev-libs/popt
	dev-libs/elfutils"

S=${WORKDIR}/${P}

src_compile() {
	emake CC="$(tc-getCC)" || die "emake failed"
}

src_install() {
	dobin debugedit
}
