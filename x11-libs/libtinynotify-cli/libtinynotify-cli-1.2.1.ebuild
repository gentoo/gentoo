# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_P=tinynotify-send-${PV}
DESCRIPTION="Common CLI routines for tinynotify-send & sw-notify-send"
HOMEPAGE="https://github.com/mgorny/tinynotify-send/"
SRC_URI="https://github.com/mgorny/tinynotify-send/releases/download/${MY_P}/${MY_P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc static-libs"

RDEPEND="x11-libs/libtinynotify:0="
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( dev-util/gtk-doc )"

S=${WORKDIR}/${MY_P}

src_configure() {
	local myconf=(
		$(use_enable doc gtk-doc)
		$(use_enable static-libs static)
		--disable-regular
		--disable-system-wide
	)

	econf "${myconf[@]}"
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
