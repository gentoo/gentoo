# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit desktop toolchain-funcs flag-o-matic

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
	https://dev.gentoo.org/~pacho/${PN}/${PN}_256.png
"
S="${WORKDIR}"

LICENSE="molmol"
SLOT="0"
KEYWORDS="amd64 ~ppc ~x86"

RDEPEND="
	|| (
		(
			media-libs/mesa[X(+)]
			x11-libs/libGLw
		)
		media-libs/mesa[motif(-),X(+)]
	)
	media-libs/libjpeg-turbo:=
	media-libs/libpng:=
	media-libs/tiff:=
	virtual/zlib:=
	virtual/glu
	x11-libs/libXpm
	x11-libs/motif:0
	x11-apps/xdpyinfo
	media-fonts/font-adobe-100dpi
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-gcc14-fix.patch
	# Patch from http://pjf.net/science/molmol.html, where src.rpm is provided
	"${WORKDIR}"/patches/pjf_RH9_molmol2k2.diff
	"${WORKDIR}"/patches/ldflags.patch
	"${WORKDIR}"/patches/opengl.patch
	"${WORKDIR}"/patches/cast.patch
	# patch from fink
	# fixes numerous bad bracings and hopefully the OGL bug 429974
	"${WORKDIR}"/patches/${P}-fink.patch
	"${WORKDIR}"/patches/wild.patch

	"${FILESDIR}"/${P}-transform-makefiles.patch
)

pkg_setup() {
	MMDIR="/usr/$(get_libdir)/molmol"
}

src_prepare() {
	default
	eapply -p0 "${WORKDIR}"/patches/libpng15.patch
	rm -rf tiff*

	sed \
		-e "s|^MOLMOLHOME.*|MOLMOLHOME=${EPREFIX}/${MMDIR}|" \
		-i "${S}"/molmol || die

	ln -s makedef.lnx "${S}"/makedef || die

	# Parallel build fails (#880621) and cannot be disabled by MAKEOPTS
	# (#880621, #941488).
	find . -name Makefile -exec sed -i -e "1i .NOTPARALLEL:" {} + || die

	# https://bugs.gentoo.org/944200
	# uses C polymorphism. Can't be trivially patched
	append-cflags -std=gnu17
	tc-export AR CC
}

src_install() {
	dobin molmol

	exeinto ${MMDIR}
	doexe src/main/molmol
	insinto ${MMDIR}
	doins -r auxil help macros man setup tips

	make_desktop_entry "${PN}" MOLMOL
	newicon "${DISTDIR}/${PN}_256.png" "${PN}.png"

	einstalldocs
	dodoc HISTORY
}
