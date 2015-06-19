# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/mulk/mulk-0.6.0.ebuild,v 1.1 2011/08/07 17:38:25 hwoarang Exp $

EAPI="4"

inherit base

MY_PV=${PV/_beta/}
MY_P="${PN}-${MY_PV}"

DESCRIPTION="Download agent similar to wget/curl"
HOMEPAGE="http://mulk.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="checksum debug metalink"

DEPEND="net-misc/curl
	app-text/htmltidy
	dev-libs/uriparser
	metalink? (
		media-libs/libmetalink
		checksum? ( dev-libs/openssl )
	)"

REQUIRE_USE="checksum? ( metalink )"

RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}"/${P}-large-file.patch
)

src_configure() {
	econf \
		$(use_enable debug) \
		$(use_enable metalink) \
		$(use metalink && use checksum && echo --enable-checksum)
}
