# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Smart Common Input Method (SCIM) Smart Pinyin Input Method"
HOMEPAGE="http://www.scim-im.org/"
SRC_URI="mirror://sourceforge/scim/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE="nls"

RDEPEND="
	>=app-i18n/scim-1.1
	x11-libs/libXt
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

PATCHES=( "${FILESDIR}"/${PN}-0.5.91-fixconfigure.patch )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--disable-skim-support \
		--disable-static \
		$(use_enable nls)
}

src_install() {
	default

	# only plugins
	find "${ED}" -name '*.la' -delete || die
}
