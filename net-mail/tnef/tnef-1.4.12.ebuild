# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/tnef/tnef-1.4.12.ebuild,v 1.4 2015/06/26 08:54:55 ago Exp $

EAPI=5

DESCRIPTION="Decodes MS-TNEF MIME attachments"
HOMEPAGE="http://world.std.com/~damned/software.html http://tnef.sourceforge.net/"
SRC_URI="mirror://sourceforge/tnef/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 hppa ~ppc ppc64 ~sparc x86"

src_test() {
	emake -j1 check
}
