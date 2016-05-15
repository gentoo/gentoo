# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit autotools-utils

DESCRIPTION="Smart Common Input Method (SCIM) Smart Pinyin Input Method"
HOMEPAGE="http://www.scim-im.org/"
SRC_URI="mirror://sourceforge/scim/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 ~x86"
IUSE="nls"

RDEPEND="x11-libs/libXt
	|| ( >=app-i18n/scim-1.1 >=app-i18n/scim-cvs-1.1 )
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"
AUTOTOOLS_AUTORECONF=1
PATCHES=(
	"${FILESDIR}/${PN}-0.5.91-fixconfigure.patch"
)
DOCS=( AUTHORS NEWS README ChangeLog )

src_configure() {
	local myeconfargs=(
		$(use_enable nls)
		--disable-skim-support
		--without-arts
		--disable-static
		--disable-depedency-tracking
	)
	autotools-utils_src_configure
}
