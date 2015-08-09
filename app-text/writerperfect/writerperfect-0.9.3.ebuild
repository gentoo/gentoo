# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Various formats to Open document format converter"
HOMEPAGE="http://libwpd.sf.net"
SRC_URI="mirror://sourceforge/libwpd/${P}.tar.xz"

LICENSE="|| ( LGPL-2.1 MPL-2.0 )"
SLOT="0"
# KEYWORDS="~amd64 ~x86 ~x86-linux ~x86-solaris"
IUSE="abiword +cdr debug ebook freehand gsf keynote +mspub +mwaw pagemaker +visio +wpd +wpg +wps"

# FIXME: libepubgen, libeot, librvngabw
RDEPEND="
	=app-text/libodfgen-0.1*
	>=dev-libs/librevenge-0.0.1
	abiword? ( =app-text/libabw-0.1* )
	cdr? ( =media-libs/libcdr-0.1* )
	ebook? ( =app-text/libebook-0.1* )
	freehand? ( =media-libs/libfreehand-0.1* )
	gsf? ( gnome-extra/libgsf )
	keynote? ( =app-text/libetonyek-0.1* )
	mspub? ( =app-text/libmspub-0.1* )
	mwaw? ( =app-text/libmwaw-0.3* )
	pagemaker? ( media-libs/libpagemaker )
	visio? ( =media-libs/libvisio-0.1* )
	wpd? ( app-text/libwpd:0.10 )
	wpg? ( =app-text/libwpg-0.3* )
	wps? ( =app-text/libwps-0.4* )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

src_configure() {
	econf \
		--disable-werror \
		$(use_enable debug) \
		$(use_with abiword libabw) \
		$(use_with cdr libcdr) \
		$(use_with ebook libebook) \
		$(use_with freehand libfreehand) \
		$(use_with gsf libgsf) \
		$(use_with keynote libetonyek) \
		$(use_with mspub libmspub) \
		$(use_with mwaw libmwaw) \
		$(use_with pagemaker libpagemaker) \
		$(use_with visio libvisio) \
		$(use_with wpd libwpd) \
		$(use_with wpg libwpg) \
		$(use_with wps libwps)
}
