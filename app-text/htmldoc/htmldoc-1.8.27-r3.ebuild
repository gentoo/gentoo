# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/htmldoc/htmldoc-1.8.27-r3.ebuild,v 1.9 2013/12/26 00:41:50 dilfridge Exp $

EAPI="4"
inherit eutils

DESCRIPTION="Convert HTML pages into a PDF document"
SRC_URI="http://www.msweet.org/files/project1/${P}-source.tar.bz2"
HOMEPAGE="http://www.msweet.org/projects.php?Z1"

IUSE="fltk ssl"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="alpha amd64 ~arm hppa ia64 ppc ppc64 sparc x86"

DEPEND=">=media-libs/libpng-1.4
	virtual/jpeg
	fltk? ( x11-libs/fltk:1 )
	ssl? ( >=dev-libs/openssl-0.9.6e )"
RDEPEND="${DEPEND}"

# this needs to be figured out, since htmldoc looks for all three libs
# right now there's no virtual/ssl
#
#   --enable-openssl        use OpenSSL for SSL/TLS support, default=yes
#   --enable-gnutls         use GNU TLS for SSL/TLS support, default=yes
#   --enable-cdsassl        use CDSA for SSL/TLS support, default=yes

src_prepare() {
	# make sure not to use the libs htmldoc ships with
	mkdir foo ; mv jpeg foo/ ; mv png foo/ ; mv zlib foo/

	epatch \
		"${FILESDIR}"/${PN}-sscanf-overflows.patch \
		"${FILESDIR}"/${PN}-fortify-fail.patch \
		"${FILESDIR}"/${PN}-libpng15.patch \
		"${FILESDIR}"/${P}-crash.patch

	sed -i "s:^#define DOCUMENTATION \"\$prefix/share/doc/htmldoc\":#define DOCUMENTATION \"\$prefix/share/doc/${PF}/html\":" \
		configure || die
}

src_configure() {
	local myconf="$(use_enable ssl openssl) $(use_with fltk gui)"
	econf ${myconf}
	# Add missing -lfltk_images to LIBS
	if use fltk; then
		sed -i 's:-lfltk :-lfltk -lfltk_images :g' Makedefs || die
	fi
}

src_install() {
	einstall bindir="${D}/usr/bin"

	# Minor cleanups
	mv "${D}/usr/share/doc/htmldoc" "${D}/usr/share/doc/${PF}"
	dodir /usr/share/doc/${PF}/html
	mv "${D}"/usr/share/doc/${PF}/*.html "${D}/usr/share/doc/${PF}/html"
}
