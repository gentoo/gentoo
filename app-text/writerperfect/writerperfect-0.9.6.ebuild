# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Various formats to Open document format converter"
HOMEPAGE="http://libwpd.sf.net"
SRC_URI="mirror://sourceforge/libwpd/${P}.tar.xz"

LICENSE="|| ( LGPL-2.1 MPL-2.0 )"
SLOT="0"
KEYWORDS="amd64 x86 ~x86-linux ~x86-solaris"
IUSE="abiword +cdr debug ebook epub freehand gsf keynote +mspub +mwaw pagemaker qxp +visio +wpd +wpg +wps zmf"

# configure fails if no import library is selected...
REQUIRED_USE="
	|| ( abiword cdr ebook freehand keynote mspub mwaw pagemaker qxp visio wpd wpg wps zmf )
"

# FIXME: librvngabw
BDEPEND="
	virtual/pkgconfig
"
DEPEND="
	=app-text/libodfgen-0.1*
	>=dev-libs/librevenge-0.0.1
	media-libs/libeot
	abiword? ( =app-text/libabw-0.1* )
	cdr? ( =media-libs/libcdr-0.1* )
	ebook? ( =app-text/libebook-0.1* )
	epub? ( app-text/libepubgen )
	freehand? ( =media-libs/libfreehand-0.1* )
	gsf? ( gnome-extra/libgsf )
	keynote? ( =app-text/libetonyek-0.1* )
	mspub? ( =app-text/libmspub-0.1* )
	mwaw? ( =app-text/libmwaw-0.3* )
	pagemaker? ( media-libs/libpagemaker )
	qxp? ( app-text/libqxp )
	visio? ( =media-libs/libvisio-0.1* )
	wpd? ( app-text/libwpd:0.10 )
	wpg? ( =app-text/libwpg-0.3* )
	wps? ( =app-text/libwps-0.4* )
	zmf? ( media-libs/libzmf )
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${P}-gsf-buildfix.patch" )

src_configure() {
	local myeconfargs=(
		--disable-werror
		$(use_with abiword libabw)
		$(use_with cdr libcdr)
		$(use_enable debug)
		$(use_with ebook libebook)
		$(use_with epub libepubgen)
		$(use_with freehand libfreehand)
		$(use_with gsf libgsf)
		$(use_with keynote libetonyek)
		$(use_with mspub libmspub)
		$(use_with mwaw libmwaw)
		$(use_with pagemaker libpagemaker)
		$(use_with qxp libqxp)
		$(use_with visio libvisio)
		$(use_with wpd libwpd)
		$(use_with wpg libwpg)
		$(use_with wps libwps)
		$(use_with zmf libzmf)
	)
	econf "${myeconfargs[@]}"
}
