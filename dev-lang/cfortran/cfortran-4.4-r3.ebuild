# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils

DEB_PR="14"

DESCRIPTION="Header file allowing to call Fortran routines from C and C++"
HOMEPAGE="http://www-zeus.desy.de/~burow/cfortran/"
SRC_URI="
	mirror://debian/pool/main/c/${PN}/${PN}_${PV}.orig.tar.gz
	mirror://debian/pool/main/c/${PN}/${PN}_${PV}-${DEB_PR}.diff.gz"

SLOT="0"
LICENSE="LGPL-2"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE="examples"

src_unpack() {
	default
	if use examples; then
		tar xvzf "${S}"/cfortran.examples.tar.gz || die
		mv eg examples || die
		ln -sfn sz1.c examples/sz1/sz1.C || die
		ln -sfn pz.c examples/pz/pz.C || die
	fi
}

src_prepare() {
	epatch "${WORKDIR}"/${PN}_${PV}-${DEB_PR}.diff
}

src_install() {
	insinto /usr/include/cfortran
	doins cfortran.h

	dosym cfortran/cfortran.h /usr/include/cfortran.h

	dodoc cfortran.doc debian/{NEWS,changelog,copyright}

	dohtml cfortran.html index.htm  cfortest.c cfortex.f

	if use examples; then
		insinto /usr/share/${PN}
		doins -r "${WORKDIR}"/examples
	fi
}
