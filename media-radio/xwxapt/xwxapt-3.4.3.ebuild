# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="GTK+ linux weather satellite APT image decoder software"
HOMEPAGE="https://www.qsl.net/5b4az/pages/apt.html"
SRC_URI="https://www.qsl.net/5b4az/pkg/apt/${PN}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-libs/glib:2
	media-libs/alsa-lib
	net-wireless/rtl-sdr
	x11-libs/gtk+:3"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${PN}-fix-autotools.patch
		  "${FILESDIR}"/${PN}-example-data.patch )
HTML_DOCS=( doc/xwxapt.html )

src_prepare() {
	default

	eautoreconf
}

src_install() {
	default

	docompress -x /usr/share/man/man1/xwxapt.1.gz
	rm "${D}"/usr/share/doc/${P}/${PN}.1.gz || die
	rm "${D}"/usr/share/doc/${P}/${PN}.html || die
	mv "${D}"/usr/share/examples/xwxapt "${D}"/usr/share || die
	keepdir /usr/share/${PN}/images /usr/share/${PN}/records
}
