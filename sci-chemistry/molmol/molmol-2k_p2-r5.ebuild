# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit desktop prefix toolchain-funcs

MY_PV="${PV/_p/.}.0"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="Publication-quality molecular visualization package"

# Original page dead
#HOMEPAGE="http://hugin.ethz.ch/wuthrich/software/molmol/index.html"
HOMEPAGE="
	http://www.csb.yale.edu/userguides/graphics/molmol/molmol_descrip.html
	http://pjf.net/science/molmol.html
"
SRC_URI="
	ftp://ftp.mol.biol.ethz.ch/software/MOLMOL/unix-gzip/${MY_P}-src.tar.gz
	ftp://ftp.mol.biol.ethz.ch/software/MOLMOL/unix-gzip/${MY_P}-doc.tar.gz
	https://dev.gentoo.org/~soap/distfiles/${PN}-patches.tbz2
	https://dev.gentoo.org/~pacho/${PN}/${PN}.png
"

LICENSE="molmol"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	|| (
		(	media-libs/mesa[X(+)]
			x11-libs/libGLw )
		media-libs/mesa[motif,X(+)] )
	media-libs/libpng:0=
	media-libs/tiff:0
	sys-libs/zlib
	virtual/glu
	virtual/jpeg:0
	x11-libs/libXpm
	x11-libs/motif:0
	x11-apps/xdpyinfo
"
DEPEND="${RDEPEND}"
BDEPEND=""

S="${WORKDIR}"

MAKEOPTS="${MAKEOPTS} -j1"

pkg_setup() {
	MMDIR="/usr/$(get_libdir)/molmol"
}

src_prepare() {
	default

	rm -rf tiff*
	# Patch from http://pjf.net/science/molmol.html, where src.rpm is provided
	eapply "${WORKDIR}"/patches/pjf_RH9_molmol2k2.diff

	eapply "${WORKDIR}"/patches/ldflags.patch
	eapply "${WORKDIR}"/patches/opengl.patch

	ln -s makedef.lnx "${S}"/makedef || die

	sed \
		-e "s:ksh:sh:" \
		-e "s:^MOLMOLHOME.*:MOLMOLHOME=${EPREFIX}/${MMDIR};MOLMOLDEV=\"Motif/OpenGL\":" \
		-i "${S}"/molmol || die
	sed \
		-e "s:^MCFLAGS.*:MCFLAGS = ${CFLAGS}:" \
		-e "s:^CC.*:CC = $(tc-getCC):" \
		-i "${S}"/makedef || die

	eapply "${WORKDIR}"/patches/cast.patch
	eapply -p0 "${WORKDIR}"/patches/libpng15.patch

	# patch from fink
	# fixes numerous bad bracings and hopefully the OGL bug 429974
	eapply "${WORKDIR}"/patches/${P}-fink.patch

	eapply "${WORKDIR}"/patches/wild.patch
	tc-export AR
}

src_install() {
	dobin molmol

	exeinto ${MMDIR}
	doexe src/main/molmol
	insinto ${MMDIR}
	doins -r auxil help macros man setup tips

	make_desktop_entry "${PN}"
	doicon "${DISTDIR}/${PN}.png"

	einstalldocs
	dodoc HISTORY
}
