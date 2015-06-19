# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/hp2xx/hp2xx-3.4.4.ebuild,v 1.2 2012/04/24 10:07:08 mgorny Exp $

EAPI=4

inherit eutils base

DESCRIPTION="Versatile tool to convert Hewlett-Packard's HP-GL plotter language into other graphics formats"
HOMEPAGE="http://www.gnu.org/software/hp2xx/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="
	media-libs/libpng
	media-libs/tiff
	sys-libs/zlib
	virtual/jpeg
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${P}-r1.patch" )

src_prepare() {
	base_src_prepare
	cp -v makes/generic.mak sources/Makefile || die
}

src_compile() {
	cd "${S}/sources" || die
	emake all
}

src_install() {
	dodir /usr/bin /usr/share/info /usr/share/man/man1

	make prefix="${D}/usr" \
		mandir="${D}/usr/share/man" \
		infodir="${D}/usr/share/info" \
		install || die
}
