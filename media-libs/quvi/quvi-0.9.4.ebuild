# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/quvi/quvi-0.9.4.ebuild,v 1.1 2013/11/06 06:26:49 radhermit Exp $

EAPI=5
AUTOTOOLS_AUTORECONF=1

inherit autotools-utils

DESCRIPTION="A command line tool for parsing video download links"
HOMEPAGE="http://quvi.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PV:0:3}/${P}.tar.xz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="json nls xml"

RDEPEND=">=dev-libs/glib-2.24:2
	>=net-misc/curl-7.21.0
	>=media-libs/libquvi-0.9.2:=
	json? ( >=dev-libs/json-glib-0.12 )
	nls? ( virtual/libintl )
	xml? ( >=dev-libs/libxml2-2.7.8:2 )"
DEPEND="${RDEPEND}
	app-arch/xz-utils
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

PATCHES=( "${FILESDIR}"/${PN}-0.9.1-automagic.patch )

src_configure() {
	local myeconfargs=(
		--with-manual
		$(use_enable json)
		$(use_enable xml)
	)
	autotools-utils_src_configure
}
