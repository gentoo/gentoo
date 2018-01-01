# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils multilib prefix toolchain-funcs

MY_PV="${PV/_p/.}.0"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="Publication-quality molecular visualization package"
HOMEPAGE="http://hugin.ethz.ch/wuthrich/software/molmol/index.html"
SRC_URI="
	ftp://ftp.mol.biol.ethz.ch/software/MOLMOL/unix-gzip/${MY_P}-src.tar.gz
	ftp://ftp.mol.biol.ethz.ch/software/MOLMOL/unix-gzip/${MY_P}-doc.tar.gz
	https://dev.gentoo.org/~soap/distfiles/${PN}-patches.tbz2"

LICENSE="molmol"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="
	|| (
		(	media-libs/mesa
			x11-libs/libGLw )
		media-libs/mesa[motif] )
	media-libs/libpng:0
	media-libs/tiff:0
	sys-libs/zlib
	virtual/glu
	virtual/jpeg:0
	x11-libs/libXpm
	x11-libs/motif:0
	x11-apps/xdpyinfo"
RDEPEND="${DEPEND}"

S="${WORKDIR}"

MAKEOPTS="${MAKEOPTS} -j1"

pkg_setup() {
	MMDIR="/usr/$(get_libdir)/molmol"
}

src_prepare() {
	rm -rf tiff*
	# Patch from http://pjf.net/science/molmol.html, where src.rpm is provided
	epatch "${WORKDIR}"/patches/pjf_RH9_molmol2k2.diff

	epatch "${WORKDIR}"/patches/ldflags.patch
	epatch "${WORKDIR}"/patches/opengl.patch

	ln -s makedef.lnx "${S}"/makedef || die

	sed \
		-e "s:ksh:sh:" \
		-e "s:^MOLMOLHOME.*:MOLMOLHOME=${EPREFIX}/${MMDIR};MOLMOLDEV=\"Motif/OpenGL\":" \
		-i "${S}"/molmol || die
	sed \
		-e "s:^MCFLAGS.*:MCFLAGS = ${CFLAGS}:" \
		-e "s:^CC.*:CC = $(tc-getCC):" \
		-i "${S}"/makedef || die

	epatch "${WORKDIR}"/patches/cast.patch
	epatch "${WORKDIR}"/patches/libpng15.patch

	# patch from fink
	# fixes numerous bad bracings and hopefully the OGL bug 429974
	epatch "${WORKDIR}"/patches/${P}-fink.patch

	epatch "${WORKDIR}"/patches/wild.patch
	tc-export AR
}

src_install() {
	dobin molmol

	exeinto ${MMDIR}
	doexe src/main/molmol
	insinto ${MMDIR}
	doins -r auxil help macros man setup tips

	dodoc HISTORY README
}
