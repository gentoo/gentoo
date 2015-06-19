# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-doc/mkdoxy/mkdoxy-1.0.0.ebuild,v 1.12 2006/05/03 01:02:12 weeve Exp $

DESCRIPTION="mkDoxy generates Doxygen-compatible HTML documentation for makefiles"
HOMEPAGE="http://sourceforge.net/projects/mkdoxy/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc sparc x86"
IUSE=""

DEPEND="app-doc/doxygen
	>=dev-lang/perl-5"

src_install() {
	dobin mkdoxy
	dodoc AUTHORS ChangeLog INSTALL INSTALL.gentoo README TODO VERSION
}
