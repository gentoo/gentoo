# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# do not use autotools related stuff in stable ebuilds
# unless you like random breakage: 469796, 469798, 424041

EAPI=6

inherit autotools eutils gnome2-utils

DESCRIPTION="Free Awale - The game of all Africa"
HOMEPAGE="http://www.nongnu.org/awale/"
SRC_URI="mirror://nongnu/awale/${P}.tar.gz"
SRC_URI="${SRC_URI} https://dev.gentoo.org/~hasufell/distfiles/${P}-no-autoreconf2.patch.xz" # STABLE ARCH

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="tk"

RDEPEND="tk? ( dev-lang/tcl:0= dev-lang/tk:0= )"

PATCHES=(
	"${FILESDIR}"/${P}-build.patch
)

src_prepare() {
	default

	mv src/xawale.tcl src/xawale.tcl.in || die
	mv configure.{in,ac} || die
	rm aclocal.m4 || die
	eautoreconf
}

src_configure() {
	econf \
		--mandir=/usr/share/man \
		--with-iconsdir=/usr/share/icons/hicolor/48x48/apps \
		--with-desktopdir=/usr/share/applications \
		$(use_enable tk)
}

src_install() {
	default
	use tk && fperms +x /usr/share/${PN}/xawale.tcl
}

pkg_preinst() {
	use tk && gnome2_icon_savelist
}

pkg_postinst() {
	use tk && gnome2_icon_cache_update
}

pkg_postrm() {
	use tk && gnome2_icon_cache_update
}
