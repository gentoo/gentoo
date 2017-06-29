# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit autotools-utils

MY_P=tinynotify-send-${PV}
DESCRIPTION="A system-wide variant of tinynotify-send"
HOMEPAGE="https://github.com/mgorny/tinynotify-send/"
SRC_URI="https://github.com/mgorny/tinynotify-send/releases/download/${MY_P}/${MY_P}.tar.bz2"

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
