# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

WX_GTK_VER=3.0-gtk3

inherit wxwidgets

DESCRIPTION="Experimental x-y data reading library"
HOMEPAGE="https://github.com/wojdyr/xylib"
SRC_URI="https://github.com/wojdyr/xylib/releases/download/v${PV}/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="bzip2 gui zlib"

RDEPEND="
	bzip2? ( app-arch/bzip2 )
	gui? ( x11-libs/wxGTK:${WX_GTK_VER} )
	zlib? ( sys-libs/zlib )"
DEPEND="
	${RDEPEND}
	dev-libs/boost"

src_configure() {
	use gui && setup-wxwidgets

	econf \
		--disable-static \
		$(use_with bzip2 bzlib) \
		$(use_with gui) \
		$(use_with zlib)
}

src_install() {
	default

	# no static archives
	find "${ED}" -name '*.la' -delete || die
}
