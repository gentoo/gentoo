# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/sblim-sfcc/sblim-sfcc-2.2.5.ebuild,v 1.1 2013/03/18 06:37:17 qnikst Exp $

EAPI=5

AUTOTOOLS_IN_SOURCE_BUILD=1

inherit autotools-utils

DESCRIPTION="Small Footprint CIM Client Library"
HOMEPAGE="http://sourceforge.net/apps/mediawiki/sblim"
SRC_URI="mirror://sourceforge/project/sblim/${PN}/${P}.tar.bz2"

LICENSE="EPL-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	net-misc/curl[ssl]
	"
RDEPEND="${DEPEND}"
DOCS=()

src_configure() {
	local myeconfargs=(
		--enable-http-chunking
		)
	autotools-utils_src_configure
}
