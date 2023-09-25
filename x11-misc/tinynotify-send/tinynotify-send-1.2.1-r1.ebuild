# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A notification sending utility (using libtinynotify)"
HOMEPAGE="https://github.com/projg2/tinynotify-send/"
SRC_URI="https://github.com/projg2/tinynotify-send/releases/download/${P}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	x11-libs/libtinynotify:0=
	~x11-libs/libtinynotify-cli-${PV}
"
RDEPEND="
	${DEPEND}
	app-eselect/eselect-notify-send
"
BDEPEND="
	virtual/pkgconfig
"

src_configure() {
	local myconf=(
		--disable-library
		--enable-regular
		--disable-system-wide
		--with-system-wide-exec=/usr/bin/sw-notify-send
	)

	econf "${myconf[@]}"
}

pkg_postinst() {
	eselect notify-send update ifunset
}

pkg_postrm() {
	eselect notify-send update ifunset
}
