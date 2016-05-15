# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_IN_SOURCE_BUILD=1

inherit eutils autotools-utils multilib

DESCRIPTION="World Coordinate System library for astronomical FITS images"
HOMEPAGE="http://tdc-www.harvard.edu/software/wcstools"
SRC_URI="${HOMEPAGE}/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE=""

DOCS=( Readme Programs NEWS )

PATCHES=(
	"${FILESDIR}"/wcstools-3.9.2-compiler_warnings.patch
	"${FILESDIR}"/wcstools-3.9.2-mayhem.patch
	"${FILESDIR}"/wcstools-3.9.2-RASortStars.patch
	"${FILESDIR}"/wcstools-3.9.2-spelling.patch
	"${FILESDIR}"/wcstools-3.9.2-sprintf.patch
	"${FILESDIR}"/wcstools-3.9.2-use_abort.patch
	"${FILESDIR}"/wcstools-3.9.2-wcsinit_crash.patch
)

src_prepare() {
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
	autotools-utils_src_prepare
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
	autotools-utils_src_install
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
