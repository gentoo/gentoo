# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

#if LIVE
AUTOTOOLS_AUTORECONF=yes
EGIT_REPO_URI="https://github.com/mgorny/tinynotify-send.git"

inherit git-r3
#endif

inherit autotools-utils

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

#if LIVE
KEYWORDS=
SRC_URI=
DEPEND="${DEPEND}
	>=dev-util/gtk-doc-1.18"
#endif

src_configure() {
	local myeconfargs=(
		$(use_enable doc gtk-doc)
		--disable-regular
		--disable-system-wide
	)

	autotools-utils_src_configure
}
