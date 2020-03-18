# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

PATCH_LEVEL=12
MY_PN=${PN/gtk-engines-}

DESCRIPTION="A derivative of the standard Clearlooks GTK+ 2.x engine with more orange feel"
HOMEPAGE="http://packages.ubuntu.com/search?keywords=gtk2-engines-ubuntulooks"
SRC_URI="
	mirror://ubuntu/pool/main/u/${MY_PN}/${MY_PN}_${PV}.orig.tar.gz
	mirror://ubuntu/pool/main/u/${MY_PN}/${MY_PN}_${PV}-${PATCH_LEVEL}.diff.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86 ~amd64-linux ~x86-linux ~x86-macos"

RDEPEND="
	dev-libs/glib:2
	x11-libs/gtk+:2"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

S=${WORKDIR}/${MY_PN}-${PV}

PATCHES=(
	"${WORKDIR}"/${MY_PN}_${PV}-${PATCH_LEVEL}.diff
	"${S}"/debian/patches/01_fix_listview_arrows_drawing.patch
	"${S}"/debian/patches/01_fix_tick_box_drawing.patch
	"${S}"/debian/patches/01_progressbar-fix.patch
	"${S}"/debian/patches/02_fix-firefox-buttons.patch
	# https://bugs.gentoo.org/419395
	"${FILESDIR}"/${P}-glib-2.31.patch
)

src_prepare() {
	default
	eautoreconf # update libtool for interix
}

src_configure() {
	econf --enable-animation
}

src_install() {
	default
	newdoc debian/changelog ChangeLog.debian

	# no static archives
	find "${D}" -name '*.la' -delete || die
}
