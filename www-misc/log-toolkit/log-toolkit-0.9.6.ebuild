# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-misc/log-toolkit/log-toolkit-0.9.6.ebuild,v 1.5 2008/02/02 13:19:15 hollow Exp $

inherit depend.apache

DESCRIPTION="set of tools to manipulate and maintain webserver logfiles"
HOMEPAGE="http://sourceforge.net/projects/log-toolkit/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

need_apache

src_install() {
	make DESTDIR="${D}" install || die "install failed"
	dodoc AUTHORS BUGS ChangeLog NEWS README TODO
}
