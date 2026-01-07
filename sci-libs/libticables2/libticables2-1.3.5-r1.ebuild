# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Library to handle different link cables for TI calculators"
HOMEPAGE="http://lpg.ticalc.org/prj_tilp/"
SRC_URI="https://downloads.sourceforge.net/tilp/tilp2-linux/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="debug doc nls static-libs usb"

RDEPEND="
	dev-libs/glib:2
	usb? ( virtual/libusb:1 )
	nls? ( virtual/libintl )
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"

DOCS=( AUTHORS LOGO NEWS README ChangeLog docs/api.txt )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--disable-rpath
		$(use_enable static-libs static)
		$(use_enable debug logging)
		$(use_enable nls)
		$(use_enable usb libusb)
		$(use_enable usb libusb10)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	use doc && HTML_DOCS+=( docs/html/. )
	default
	find "${D}" -type f -name '*.la' -delete || die
}

pkg_postinst() {
	elog "Please read README in ${EROOT}/usr/share/doc/${PF}"
	elog "if you encounter any problem with a link cable"
}
