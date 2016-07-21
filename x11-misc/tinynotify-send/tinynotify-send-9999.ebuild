# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

#if LIVE
AUTOTOOLS_AUTORECONF=yes
EGIT_REPO_URI="https://bitbucket.org/mgorny/${PN}.git"

inherit git-r3
#endif

inherit autotools-utils

DESCRIPTION="A notification sending utility (using libtinynotify)"
HOMEPAGE="https://bitbucket.org/mgorny/tinynotify-send/"
SRC_URI="https://www.bitbucket.org/mgorny/${PN}/downloads/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="app-eselect/eselect-notify-send
	x11-libs/libtinynotify:0=
	~x11-libs/libtinynotify-cli-${PV}"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

#if LIVE
KEYWORDS=
SRC_URI=
DEPEND="${DEPEND}
	dev-util/gtk-doc"
#endif

src_configure() {
	myeconfargs=(
		--disable-library
		--enable-regular
		--disable-system-wide
		--with-system-wide-exec=/usr/bin/sw-notify-send
	)

	autotools-utils_src_configure
}

pkg_postinst() {
	eselect notify-send update ifunset
}

pkg_postrm() {
	eselect notify-send update ifunset
}
