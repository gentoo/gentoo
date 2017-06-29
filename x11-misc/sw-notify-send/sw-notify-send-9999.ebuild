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
DESCRIPTION="A system-wide variant of tinynotify-send"
HOMEPAGE="https://github.com/mgorny/tinynotify-send/"
SRC_URI="https://github.com/mgorny/tinynotify-send/releases/download/${MY_P}/${MY_P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="x11-libs/libtinynotify:0=
	~x11-libs/libtinynotify-cli-${PV}
	x11-libs/libtinynotify-systemwide:0="
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${MY_P}

#if LIVE
EGIT_CHECKOUT_DIR=${WORKDIR}/${MY_P}
KEYWORDS=
SRC_URI=
DEPEND="${DEPEND}
	dev-util/gtk-doc"
#endif

src_configure() {
	myeconfargs=(
		--disable-library
		--disable-regular
		--enable-system-wide
	)

	autotools-utils_src_configure
}
