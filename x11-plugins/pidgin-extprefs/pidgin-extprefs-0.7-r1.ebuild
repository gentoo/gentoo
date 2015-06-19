# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/pidgin-extprefs/pidgin-extprefs-0.7-r1.ebuild,v 1.8 2012/05/05 05:11:58 jdhore Exp $

EAPI=2

DESCRIPTION="Extra preferences that are desired but not are not considered worthy of inclusion in Pidgin itself"
HOMEPAGE="http://gaim-extprefs.sourceforge.net"
SRC_URI="mirror://sourceforge/gaim-extprefs/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 hppa ppc sparc x86"
IUSE=""

RDEPEND="net-im/pidgin[gtk]"
DEPEND="
	virtual/pkgconfig
	${RDEPEND}"

src_install() {
	emake DESTDIR="${D}" install || die
}
