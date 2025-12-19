# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

DESCRIPTION="World Coordinate System library for astronomical FITS images"
HOMEPAGE="http://tdc-www.harvard.edu/software/wcstools/"
SRC_URI="http://tdc-www.harvard.edu/software/wcstools/${P}.tar.gz
	http://tdc-www.harvard.edu/software/wcstools/Old/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

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
	for f in "${FILESDIR}"/{configure.ac,wcstools.pc.in}; do
		cp -v ${f} "${S}"/ || die
	done
	cp -v "${FILESDIR}"/Makefile.${PV}.am "${S}"/Makefile.am || die
	cp -v "${FILESDIR}"/Makefile.libwcs.${PV}.am "${S}"/libwcs/Makefile.am || die
	# avoid colliding with fixdos, getdate and remap from other packages
	sed -i \
		-e 's/getdate/wcsgetdate/' \
		-e 's/crlf/wcscrlf/' \
		-e 's/remap/wcsremap/' \
		-e "s/3.... Programs/${PV} Programs/" \
		wcstools || die
	eautoreconf
}

src_configure() {
	# bug #943830
	append-cflags -std=gnu17

	default
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

	find "${ED}" -name '*.la' -delete || die
}

pkg_postinst() {
	elog "The following execs have been renamed to avoid colliding"
	elog "with other packages:"
	elog " getdate -> wcsgetdate"
	elog " crlf    -> wcscrlf"
	elog " remap   -> wcsremap"
}
