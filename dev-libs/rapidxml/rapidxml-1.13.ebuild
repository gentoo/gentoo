# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/rapidxml/rapidxml-1.13.ebuild,v 1.1 2014/01/13 17:42:49 jlec Exp $

EAPI=5

inherit eutils

DESCRIPTION="Fast XML parser"
HOMEPAGE="http://rapidxml.sourceforge.net/"
SRC_URI="mirror://sourceforge/rapidxml/rapidxml-${PV}.zip"

LICENSE="Boost-1.0 MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_install() {
	insinto /usr/include/rapidxml
	doins *.hpp
	dohtml manual.html
}
