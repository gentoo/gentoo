# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/burn-cd/burn-cd-1.7.4.ebuild,v 1.2 2009/02/01 12:11:55 maekke Exp $

DESCRIPTION="Smart console frontend for virtual/cdrtools and dvd+rw-tools"
HOMEPAGE="http://burn-cd.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="dev-lang/python
	virtual/cdrtools
	app-cdr/dvd+rw-tools"
DEPEND=""

src_install() {
	newbin ${P} ${PN} || die "newbin failed."
}
