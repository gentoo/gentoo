# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Smart Common Input Method (SCIM) Generic Table Input Method Server"
HOMEPAGE="http://www.scim-im.org/"
SRC_URI="https://downloads.sourceforge.net/scim/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ppc x86"
IUSE="nls"

RDEPEND="
	>=app-i18n/scim-1.4.7-r2
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

PATCHES=(
	"${FILESDIR}"/${PN}-0.5.8+gcc-4.3.patch
	"${FILESDIR}"/${PN}-0.5.12-automake.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--disable-skim-support \
		--disable-static \
		--without-arts \
		$(use_enable nls)
}

src_install() {
	default

	# no static archives
	find "${D}" -name '*.la' -delete || die
}
