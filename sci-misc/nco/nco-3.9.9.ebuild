# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-misc/nco/nco-3.9.9.ebuild,v 1.5 2011/03/17 08:17:00 xarthisius Exp $

EAPI=2
inherit eutils flag-o-matic

DESCRIPTION="Command line utilities for operating on netCDF files"
SRC_URI="http://dust.ess.uci.edu/nco/src/${P}.tar.gz"
HOMEPAGE="http://nco.sourceforge.net/"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ppc x86"

IUSE="doc mpi ncap2 udunits"

RDEPEND="sci-libs/netcdf
	mpi? ( virtual/mpi )
	udunits? ( >=sci-libs/udunits-2 )"

DEPEND="${RDEPEND}
	ncap2? ( !mpi? ( dev-java/antlr:0 ) )
	doc? ( virtual/latex-base )"

pkg_setup() {
	if use mpi && use ncap2; then
		elog
		elog "mpi and ncap2 are still incompatible flags"
		elog "nco configure will automatically disables ncap2"
		elog
	fi
}

src_configure() {
	local myconf
	if has_version ">=sci-libs/netcdf-4" && built_with_use sci-libs/netcdf hdf5; then
		append-cppflags -DHAVE_NETCDF4_H
		myconf="--enable-netcdf4"
	else
		myconf="--disable-netcdf4"
	fi
	econf \
		${myconf} \
		--disable-udunits \
		$(use_enable ncap2) \
		$(use_enable udunits udunits2) \
		$(use_enable mpi)
}

src_compile() {
	emake || die "emake failed"
	cd doc
	emake clean info
	if use doc; then
		VARTEXFONTS="${T}/fonts" emake html pdf || die "emake doc failed"
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	cd doc
	dodoc ANNOUNCE ChangeLog MANIFEST NEWS README TAG TODO VERSION *.txt \
		|| die "dodoc failed"
	doinfo *.info* || die "doinfo failed"
	if use doc; then
		dohtml nco.html/* || die "dohtml failed"
		insinto /usr/share/doc/${PF}
		doins nco.pdf || die "pdf install failed"
	fi
}
