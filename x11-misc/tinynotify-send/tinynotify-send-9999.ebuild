# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGIT_REPO_URI="https://github.com/mgorny/${PN}.git"
inherit autotools git-r3

DESCRIPTION="A notification sending utility (using libtinynotify)"
HOMEPAGE="https://github.com/mgorny/tinynotify-send/"
SRC_URI=""

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="app-eselect/eselect-notify-send
	x11-libs/libtinynotify:0=
	~x11-libs/libtinynotify-cli-${PV}"
DEPEND="${RDEPEND}
	dev-util/gtk-doc
	virtual/pkgconfig"

src_prepare() {
	default
	eautoreconf
}

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
