# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGIT_REPO_URI="https://github.com/mgorny/tinynotify-send.git"
inherit autotools git-r3

MY_P=tinynotify-send-${PV}
DESCRIPTION="Common CLI routines for tinynotify-send & sw-notify-send"
HOMEPAGE="https://github.com/mgorny/tinynotify-send/"
SRC_URI=""

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE="doc static-libs"

RDEPEND="x11-libs/libtinynotify:0="
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-1.18
	virtual/pkgconfig
	doc? ( dev-util/gtk-doc )"

src_prepare() {
	default
	eautoreconf
}

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
