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
	"${FILESDIR}"/${PN}-3.9.4-spelling.patch
	"${FILESDIR}"/${PN}-3.9.4-haspm.patch
	"${FILESDIR}"/${PN}-3.9.4-fix-tests.patch
	"${FILESDIR}"/${PN}-3.9.4-compiler-warning.patch
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
