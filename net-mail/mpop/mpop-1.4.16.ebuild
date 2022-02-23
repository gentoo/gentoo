# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A small, fast, and portable POP3 client"
HOMEPAGE="https://marlam.de/mpop/"
SRC_URI="https://marlam.de/mpop/releases/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="idn gnome-keyring nls sasl"

RDEPEND="
	idn? ( net-dns/libidn2 )
	gnome-keyring? ( app-crypt/libsecret )
	nls? ( virtual/libintl )
	sasl? ( virtual/gsasl )"

DEPEND="${RDEPEND}"

BDEPEND="
	nls? ( sys-devel/gettext )
	virtual/pkgconfig"

DOCS=( AUTHORS ChangeLog NEWS NOTES README THANKS )

src_configure() {
	econf \
		$(use_enable nls) \
		$(use_with sasl libgsasl) \
		$(use_with idn libidn) \
		$(use_with gnome-keyring libsecret)
}

src_install() {
	default

	insinto /usr/share/vim/vimfiles/syntax
	doins scripts/vim/mpop.vim
}
