# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="A command line tool for parsing video download links"
HOMEPAGE="http://quvi.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PV:0:3}/${P}.tar.xz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="amd64 ~hppa ppc ppc64 x86"
IUSE="json nls xml"

RDEPEND="
	dev-libs/glib:2
	net-misc/curl:=
	media-libs/libquvi:=
	json? ( dev-libs/json-glib:= )
	nls? ( virtual/libintl )
	xml? ( dev-libs/libxml2:2= )"
DEPEND="${RDEPEND}"
BDEPEND="
	app-arch/xz-utils
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

PATCHES=( "${FILESDIR}"/${PN}-0.9.1-automagic.patch )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--with-manual \
		$(use_enable json) \
		$(use_enable xml)
}
