# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools desktop readme.gentoo-r1

DEB_PATCH="${PN}_${PV}-7"
DESCRIPTION="OpenGL interactive relativistic simulator"
HOMEPAGE="http://lightspeed.sourceforge.net/"
SRC_URI="
	mirror://sourceforge/${PN}/${P}.tar.gz
	mirror://sourceforge/${PN}/objects-1.tar.gz
	mirror://debian/pool/main/${PN:0:1}/${PN}/${DEB_PATCH}.diff.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"

IUSE="nls truetype"

RDEPEND="
	media-libs/libpng:0=
	media-libs/tiff:0
	virtual/opengl
	x11-libs/gtkglext
	x11-libs/gtkglarea:2
	x11-libs/gtk+:2
	x11-libs/libXmu
	truetype? ( media-libs/ftgl )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

PATCHES=(
	"${WORKDIR}/${DEB_PATCH}.diff"
	"${FILESDIR}"/${P}-autoconf.patch
	"${FILESDIR}"/${P}-libpng15.patch
)

DOC_CONTENTS="
	Some 3d models have been placed in /usr/share/${PN}
	You can load them in Light Speed! from the File menu.
"

src_prepare() {
	default
	mv configure.{in,ac} || die
	eautoreconf
}

src_configure() {
	econf \
		--with-gtk=2 \
		$(use_enable nls) \
		$(use_with truetype ftgl)
}

src_install() {
	default

	newicon src/icon.xpm lightspeed.xpm
	make_desktop_entry ${PN} "Light Speed! Relativistic Simulator"

	readme.gentoo_create_doc
	newdoc debian/changelog ChangeLog.Debian
	cd "${WORKDIR}/objects" || die
	newdoc README objects-README

	insinto /usr/share/${PN}
	doins *.3ds *.lwo
}

pkg_postinst() {
	readme.gentoo_print_elog
}
