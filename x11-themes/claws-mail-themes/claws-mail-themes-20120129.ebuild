# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/claws-mail-themes/claws-mail-themes-20120129.ebuild,v 1.4 2014/03/26 20:28:42 ulm Exp $

DESCRIPTION="Iconsets for Claws Mail"
HOMEPAGE="http://www.claws-mail.org/"
SRC_URI="http://www.claws-mail.org/themes/${P}.tar.gz"

LICENSE="GPL-2 GPL-3 CC-BY-3.0 CC-BY-SA-2.5 CC-BY-NC-SA-3.0 CC-BY-ND-3.0 MPL-1.1 freedist public-domain all-rights-reserved"
SLOT="0"
KEYWORDS="alpha amd64 ppc ppc64 x86"
RESTRICT="mirror bindist"

RDEPEND="mail-client/claws-mail"
DEPEND=""

src_install() {
	insinto /usr/share/claws-mail/themes
	doins -r *
}
