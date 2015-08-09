# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit fortran-2 toolchain-funcs

DESCRIPTION="Thermal ellipsoid plot program for crystal structure illustrations"
HOMEPAGE="http://www.ornl.gov/sci/ortep/"
SRC_URI="ftp://ftp.ornl.gov/pub/ortep/src/ortep.f"

SLOT="0"
LICENSE="public-domain"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	sci-libs/pgplot
	x11-libs/libX11"
DEPEND="${RDEPEND}"

S="${WORKDIR}"

src_unpack() {
	cp "${DISTDIR}"/${A} "${S}" || die
}

src_compile() {
	COMMAND="$(tc-getFC) ${FFLAGS:- -O2} ${LDFLAGS} -o ${PN} ortep.f -lpgplot -lX11"
	echo ${COMMAND}
	${COMMAND} || die "Compilation failed"
}

src_install() {
	dobin ${PN}
}
