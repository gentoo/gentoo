# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit autotools-utils

MY_PN=tinynotify-send
MY_P=${MY_PN}-${PV}

DESCRIPTION="Common CLI routines for tinynotify-send & sw-notify-send"
HOMEPAGE="https://github.com/mgorny/tinynotify-send/"
SRC_URI="mirror://github/mgorny/${MY_PN}/${MY_P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc static-libs"

RDEPEND="x11-libs/libtinynotify"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( dev-util/gtk-doc )"

DOCS=( README )
S=${WORKDIR}/${MY_P}

src_configure() {
	local myeconfargs=(
		$(use_enable doc gtk-doc)
		--disable-regular
		--disable-system-wide
	)

	autotools-utils_src_configure
}
