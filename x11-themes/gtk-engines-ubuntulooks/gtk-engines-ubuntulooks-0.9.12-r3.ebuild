# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4
inherit autotools eutils

PATCH_LEVEL=12
MY_PN=${PN/gtk-engines-}

DESCRIPTION="A derivative of the standard Clearlooks GTK+ 2.x engine with more orange feel"
HOMEPAGE="http://packages.ubuntu.com/search?keywords=gtk2-engines-ubuntulooks"
SRC_URI="mirror://ubuntu/pool/main/u/${MY_PN}/${MY_PN}_${PV}.orig.tar.gz
	mirror://ubuntu/pool/main/u/${MY_PN}/${MY_PN}_${PV}-${PATCH_LEVEL}.diff.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE=""

RDEPEND=">=dev-libs/glib-2
	x11-libs/gtk+:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${MY_PN}-${PV}

src_prepare() {
	epatch "${WORKDIR}"/${MY_PN}_${PV}-${PATCH_LEVEL}.diff
	EPATCH_FORCE=yes EPATCH_SUFFIX=patch epatch debian/patches
	epatch "${FILESDIR}"/${P}-glib-2.31.patch #419395

	eautoreconf # update libtool for interix
}

src_configure() {
	econf --enable-animation
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog README
	newdoc debian/changelog ChangeLog.debian
	find "${ED}"/usr -name '*.la' -type f -exec rm -f {} +
}
