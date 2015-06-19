# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/hello/hello-2.8.ebuild,v 1.1 2012/07/16 01:44:45 abcd Exp $

EAPI="4"

DESCRIPTION="GNU \"Hello, world\" application"
HOMEPAGE="http://www.gnu.org/software/hello/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="FDL-1.3 GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="nls"

DOCS=(AUTHORS ChangeLog ChangeLog.O NEWS README THANKS TODO contrib/evolution.txt)

src_configure() {
	econf $(use_enable nls)
}

src_install() {
	default

	for x in contrib man doc po tests src; do
		newdoc $x/ChangeLog ChangeLog.$x || die "newdoc failed"
	done
}
