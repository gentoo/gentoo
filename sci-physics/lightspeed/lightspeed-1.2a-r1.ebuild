# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-physics/lightspeed/lightspeed-1.2a-r1.ebuild,v 1.16 2012/08/07 17:35:36 bicatali Exp $

EAPI=4

inherit autotools eutils

DEB_PATCH="${PN}_${PV}-7"
DESCRIPTION="OpenGL interactive relativistic simulator"
HOMEPAGE="http://lightspeed.sourceforge.net/"
SRC_URI="
	mirror://sourceforge/${PN}/${P}.tar.gz
	mirror://sourceforge/${PN}/objects-1.tar.gz
	mirror://debian/pool/main/${PN:0:1}/${PN}/${DEB_PATCH}.diff.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux"

IUSE="nls truetype"
LANGS="es"
for i in ${LANGS}; do
	IUSE="${IUSE} linguas_${i}"
done

RDEPEND="
	media-libs/libpng
	media-libs/tiff
	virtual/opengl
	x11-libs/gtkglext
	x11-libs/gtkglarea:2
	x11-libs/gtk+:2
	x11-libs/libXmu
	truetype? ( media-libs/ftgl )"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

S2="${WORKDIR}/objects"

src_prepare() {
	epatch "${WORKDIR}/${DEB_PATCH}.diff"
	epatch \
		"${FILESDIR}"/${P}-autoconf.patch \
		"${FILESDIR}"/${P}-libpng15.patch
	eautoreconf
}

src_configure() {
	econf \
		--with-gtk=2 \
		$(use_enable nls) \
		$(use_with truetype ftgl)
}

src_compile() {
	emake
	local i
	for i in ${LANGS}; do
		use linguas_${i} && emake ${i}.gmo
	done
}

src_install() {
	default
	newicon src/icon.xpm lightspeed.xpm
	make_desktop_entry ${PN} "Light Speed! Relativistic Simulator"
	newdoc debian/changelog ChangeLog.Debian
	cd ${S2}
	newdoc README objects-README
	insinto /usr/share/${PN}
	doins *.3ds *.lwo
}

pkg_postinst() {
	elog
	elog "Some 3d models have been placed in /usr/share/${PN}"
	elog "You can load them in Light Speed! from the File menu."
	elog
}
