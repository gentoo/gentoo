# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/namd/namd-2.10.ebuild,v 1.2 2015/03/20 15:28:56 jlec Exp $

EAPI=5

inherit eutils multilib toolchain-funcs flag-o-matic

DESCRIPTION="A powerful and highly parallelized molecular dynamics code"
LICENSE="namd"
HOMEPAGE="http://www.ks.uiuc.edu/Research/namd/"

MY_PN="NAMD"

SRC_URI="${MY_PN}_${PV}_Source.tar.gz"

SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RESTRICT="fetch"

RDEPEND="
	>=sys-cluster/charm-6.5.1-r2
	sci-libs/fftw:3.0
	dev-lang/tcl:0="

DEPEND="${RDEPEND}
	app-shells/tcsh"

NAMD_ARCH="Linux-x86_64-g++"

NAMD_DOWNLOAD="http://www.ks.uiuc.edu/Development/Download/download.cgi?PackageName=NAMD"

S="${WORKDIR}/${MY_PN}_${PV}_Source"

pkg_nofetch() {
	echo
	einfo "Please download ${MY_PN}_${PV}_Source.tar.gz from"
	einfo "${NAMD_DOWNLOAD}"
	einfo "after agreeing to the license and then move it to"
	einfo "${DISTDIR}"
	einfo "Be sure to select the ${PV} version!"
	echo
}

src_prepare() {
	CHARM_VERSION=$(best_version sys-cluster/charm | cut -d- -f3)

	# apply a few small fixes to make NAMD compile and
	# link to the proper libraries
	epatch "${FILESDIR}"/namd-2.10-gentoo.patch
	epatch "${FILESDIR}"/namd-2.7-iml-dec.patch
	sed \
		-e "/CHARMBASE =/s:= .*:= /usr/bin/charm-${CHARM_VERSION}:" \
		-i Make.charm || die

	# Remove charm distribution. We don't need it.
	rm -f charm-*.tar

	# proper compiler and cflags
	sed \
		-e "s/g++.*/$(tc-getCXX)/" \
		-e "s/gcc.*/$(tc-getCC)/" \
		-e "s/CXXOPTS = .*/CXXOPTS = ${CXXFLAGS} ${LDFLAGS}/" \
		-e "s/COPTS = .*/COPTS = ${CFLAGS} ${LDFLAGS}/" \
		-i arch/${NAMD_ARCH}.arch || die

	sed \
		-e "s/gentoo-libdir/$(get_libdir)/g" \
		-e "s/gentoo-charm/charm-${CHARM_VERSION}/g" \
		-i Makefile || die "Failed gentooizing Makefile."
	sed -e "s@/lib@/$(get_libdir)@g" -e '/FFTDIR=/s@=.*@=/usr@' -i arch/Linux-x86_64.fftw3 || die
	sed -e "s/gentoo-libdir/$(get_libdir)/g" -i arch/Linux-x86_64.tcl || die
}

src_configure() {
	# configure
	./config ${NAMD_ARCH} --with-fftw3 --charm-arch . || die
}

src_compile() {
	# build namd
	cd "${S}/${NAMD_ARCH}"
	emake
}

src_install() {
	dodoc announce.txt license.txt notes.txt
	cd "${S}/${NAMD_ARCH}"

	# the binaries
	dobin ${PN}2 psfgen flipbinpdb flipdcd
}

pkg_postinst() {
	echo
	einfo "For detailed instructions on how to run and configure"
	einfo "NAMD please consults the extensive documentation at"
	einfo "http://www.ks.uiuc.edu/Research/namd/"
	einfo "and the NAMD tutorials available at"
	einfo "http://www.ks.uiuc.edu/Training/Tutorials/"
	einfo "Have fun :)"
	echo
}
