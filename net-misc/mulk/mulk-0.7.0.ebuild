# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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

src_configure() {
	econf \
		$(use_enable debug) \
		$(use_enable metalink) \
		$(use metalink && use checksum && echo --enable-checksum)
}
