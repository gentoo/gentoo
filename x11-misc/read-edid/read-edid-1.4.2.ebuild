# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/read-edid/read-edid-1.4.2.ebuild,v 1.8 2015/03/13 19:19:59 jer Exp $

EAPI=5

DESCRIPTION="Get EDID information from a PnP monitor"
HOMEPAGE="http://www.polypux.org/projects/read-edid/"
SRC_URI="http://www.polypux.org/projects/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ppc ~sparc x86"

DOCS=( AUTHORS ChangeLog NEWS README )

src_configure() {
	econf --mandir=/usr/share/man
}
