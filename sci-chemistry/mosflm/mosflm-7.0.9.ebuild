# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/mosflm/mosflm-7.0.9.ebuild,v 1.8 2015/05/15 10:58:32 pacho Exp $

EAPI=5

inherit eutils fortran-2 toolchain-funcs versionator

MY_PV="$(delete_all_version_separators)"
MY_P="${PN}${MY_PV}"

DESCRIPTION="A program for integrating single crystal diffraction data from area detectors"
HOMEPAGE="http://www.mrc-lmb.cam.ac.uk/harry/mosflm/"
SRC_URI="${HOMEPAGE}ver${MY_PV}/build-it-yourself/${MY_P}.tgz"

SLOT="0"
LICENSE="ccp4"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	app-shells/tcsh
	sci-libs/cbflib
	sci-libs/ccp4-libs
	sys-libs/ncurses
	virtual/jpeg:0=
	x11-libs/libxdl_view"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	sed \
		-e "s:../cbf/lib/libcbf.a:-lcbf -limg:g" \
		-e "s:../jpg/libjpeg.a:-ljpeg:g" \
		-i ${PN}/Makefile || die

	sed \
		-e '/jinclude.h/d' \
		-i mosflm/mosflm_jpeg.c || die

	cp DATETIME.C mosflm/datetime.c || die

	epatch \
		"${FILESDIR}"/${PV}-parallel.patch \
		"${FILESDIR}"/7.0.6-impl-dec.patch \
		"${FILESDIR}"/${P}-buffer-overflow.patch \
		"${FILESDIR}"/${PN}-7.0.7-impl-dec.patch

	rm -rf test.f {cbf,jpg}/*.{h,c} || die
}

src_compile() {
	emake \
		MOSHOME="${S}" \
		DPS="${S}" \
		FC=$(tc-getFC) \
		FLINK=$(tc-getFC) \
		CC=$(tc-getCC) \
		AR_FLAGS=vru \
		MOSLIBS="-lccp4f -lccp4c -lxdl_view $($(tc-getPKG_CONFIG) --libs ncurses) -lXt -lmmdb -lccif -lstdc++" \
		MCFLAGS="-O0 -fno-second-underscore" \
		MOSFLAGS="${FFLAGS} -fno-second-underscore" \
		FFLAGS="${FFLAGS} -fno-second-underscore" \
		CFLAGS="${CFLAGS}" \
		MOSCFLAGS="${CFLAGS}" \
		LFLAGS="${LDFLAGS}"
}

src_install() {
	exeinto /usr/libexec/ccp4/bin/
	doexe bin/ipmosflm
	dosym ../libexec/ccp4/bin/ip${PN} /usr/bin/ip${PN}
}
