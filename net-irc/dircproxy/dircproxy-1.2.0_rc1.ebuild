# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-irc/dircproxy/dircproxy-1.2.0_rc1.ebuild,v 1.5 2010/04/13 18:39:38 armin76 Exp $

inherit eutils

MY_P="${P/_rc/-RC}"
DESCRIPTION="an IRC proxy server"
HOMEPAGE="http://code.google.com/p/dircproxy"
SRC_URI="http://dircproxy.googlecode.com/files/${MY_P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="alpha amd64 ppc sparc x86"
IUSE=""

S="${WORKDIR}/${MY_P}"

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS ChangeLog FAQ NEWS HACKING README* TODO INSTALL
}
