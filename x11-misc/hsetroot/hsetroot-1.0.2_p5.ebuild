# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools eutils

DESCRIPTION="Tool which allows you to compose wallpapers ('root pixmaps') for X"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="
	mirror://debian/pool/main/h/${PN}/${PN}_${PV/_p*/}.orig.tar.gz
	mirror://debian/pool/main/h/${PN}/${PN}_${PV/_p*/}-${PV/*_p/}.debian.tar.xz
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~x86-solaris"

RDEPEND="
	>=media-libs/imlib2-1.0.6.2003[X]
	x11-libs/libX11
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
	x11-base/xorg-proto
"

DOCS="AUTHORS ChangeLog NEWS README"
PATCHES=(
	"${FILESDIR}"/${P/_p*/}-underlinking.patch
	"${WORKDIR}"/debian/patches/01_fix-no-display-crash.patch
	"${WORKDIR}"/debian/patches/02_extend-mode.patch
	"${WORKDIR}"/debian/patches/03_cover-mode.patch
)
S=${WORKDIR}/${P/_p*/}.orig

src_prepare() {
	default

	eautoreconf
}
