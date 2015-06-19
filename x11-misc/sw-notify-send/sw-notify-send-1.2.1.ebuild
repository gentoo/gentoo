# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/sw-notify-send/sw-notify-send-1.2.1.ebuild,v 1.2 2012/05/05 04:53:48 jdhore Exp $

EAPI=4

inherit autotools-utils

MY_PN=tinynotify-send
MY_P=${MY_PN}-${PV}

DESCRIPTION="A system-wide variant of tinynotify-send"
HOMEPAGE="https://github.com/mgorny/tinynotify-send/"
SRC_URI="mirror://github/mgorny/${MY_PN}/${MY_P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="x11-libs/libtinynotify
	~x11-libs/libtinynotify-cli-${PV}
	x11-libs/libtinynotify-systemwide"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( README )
S=${WORKDIR}/${MY_P}

src_configure() {
	myeconfargs=(
		--disable-library
		--disable-regular
		--enable-system-wide
	)

	autotools-utils_src_configure
}
