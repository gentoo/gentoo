# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils autotools

DESCRIPTION="World Coordinate System library for astronomical FITS images"
HOMEPAGE="http://tdc-www.harvard.edu/software/wcstools"
SRC_URI="${HOMEPAGE}/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE=""

DOCS=( Readme Programs NEWS )

PATCHES=(
	"${FILESDIR}"/${PN}-3.9.2-compiler_warnings.patch
	"${FILESDIR}"/${PN}-3.9.2-mayhem.patch
	"${FILESDIR}"/${PN}-3.9.2-RASortStars.patch
	"${FILESDIR}"/${PN}-3.9.2-spelling.patch
	"${FILESDIR}"/${PN}-3.9.2-sprintf.patch
	"${FILESDIR}"/${PN}-3.9.2-use_abort.patch
	"${FILESDIR}"/${PN}-3.9.2-wcsinit_crash.patch
	"${FILESDIR}"/${PN}-3.9.2-additional_pointer_increase.patch
	"${FILESDIR}"/${PN}-3.9.2-ctype_copy_to_wcs.patch
	"${FILESDIR}"/${PN}-3.9.2-off-by-one-allocation.patch
)

src_prepare() {
	default
	einfo "Copying gentoo autotools files"
	local f
	for f in "${FILESDIR}"/{configure.ac,wcstools.pc.in,Makefile.am}; do
		cp ${f} "${S}"/ || die
	done
	cp "${FILESDIR}"/Makefile.libwcs.am "${S}"/libwcs/Makefile.am || die
	# avoid colliding with fixdos, getdate and remap from other packages
	sed -i \
		-e 's/getdate/wcsgetdate/' \
		-e 's/crlf/wcscrlf/' \
		-e 's/remap/wcsremap/' \
		-e "s/3.... Programs/${PV} Programs/" \
		wcstools || die
	eautoreconf
}

src_test() {
	einfo "Testing various wcstools programs"
	./newfits -a 10 -j 248 41 -p 0.15 test.fits || die "test newfits failed"
	./sethead test.fits A=1 B=1 ||  die "test sethead failed"
	[[ "$(./gethead test.fits RA)" == "16:32:00.0000" ]] \
		|| die "test gethead failed"
	rm test.fits
}

src_install() {
	default
	doman man/man1/*
	newdoc libwcs/NEWS NEWS.libwcs
	newdoc libwcs/Readme Readme.libwcs

}

pkg_postinst() {
	elog "The following execs have been renamed to avoid colliding"
	elog "with other packages:"
	elog " getdate -> wcsgetdate"
	elog " crlf    -> wcscrlf"
	elog " remap   -> wcsremap"
}
