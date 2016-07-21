# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"
inherit toolchain-funcs eutils flag-o-matic multilib

MY_P=${PN}.${PV}

DESCRIPTION="A set of tools for creating TeX documents with graphics"
HOMEPAGE="http://www.xfig.org/"
SRC_URI="mirror://sourceforge/mcj/${MY_P}.tar.gz
	mirror://gentoo/fig2mpdf-1.1.2.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND="x11-libs/libXpm
	virtual/jpeg
	media-libs/libpng
	x11-apps/rgb"
DEPEND="${RDEPEND}
	x11-misc/imake
	app-text/rman"

S=${WORKDIR}/${MY_P}

sed_Imakefile() {
	# see fig2dev/Imakefile for details
	vars2subs="BINDIR=${EPREFIX}/usr/bin
			MANDIR=${EPREFIX}/usr/share/man/man\$\(MANSUFFIX\)
			XFIGLIBDIR=${EPREFIX}/usr/share/xfig
			PNGINC=-I${EPREFIX}/usr/include/X11
			XPMINC=-I${EPREFIX}/usr/include/X11
			USEINLINE=-DUSE_INLINE
			RGB=${EPREFIX}/usr/share/X11/rgb.txt
			FIG2DEV_LIBDIR=${EPREFIX}/usr/share/fig2dev"

	for variable in ${vars2subs} ; do
		varname=${variable%%=*}
		varval=${variable##*=}
		sed -i "s:^\(XCOMM\)*[[:space:]]*${varname}[[:space:]]*=.*$:${varname} = ${varval}:" "$@"
	done
}

src_prepare() {
	find . -type f -exec chmod a-x '{}' \;
	find . -name Makefile -delete
	epatch "${FILESDIR}"/${P}-fig2mpdf-r1.patch
	epatch "${FILESDIR}"/${PN}-3.2.5c-maxfontsize.patch
	epatch "${FILESDIR}"/${P}-leadspace.patch
	epatch "${FILESDIR}"/${P}-precision.patch
	epatch "${FILESDIR}"/${P}-MAXWIDTH.patch
	epatch "${FILESDIR}"/${P}-libpng-1.5.patch #356751
	epatch "${FILESDIR}"/${PN}-3.2.5-solaris.patch

	sed -e 's:-L$(ZLIBDIR) -lz::' \
		-e 's: -lX11::' \
			-i fig2dev/Imakefile || die
	sed_Imakefile fig2dev/Imakefile fig2dev/dev/Imakefile
}

src_compile() {
	xmkmf || die "xmkmf failed"
	emake Makefiles

	emake CC="$(tc-getCC)" LOCAL_LDFLAGS="${LDFLAGS}" CDEBUGFLAGS="${CFLAGS}" \
		USRLIBDIR="${EPREFIX}/usr/$(get_libdir)"
}

src_install() {
	emake DESTDIR="${D}" \
		${transfig_conf} install install.man

	dobin "${WORKDIR}/fig2mpdf/fig2mpdf"
	doman "${WORKDIR}/fig2mpdf/fig2mpdf.1"

	insinto /usr/share/fig2dev/
	newins "${FILESDIR}/transfig-ru_RU.CP1251.ps" ru_RU.CP1251.ps
	newins "${FILESDIR}/transfig-ru_RU.KOI8-R.ps" ru_RU.KOI8-R.ps
	newins "${FILESDIR}/transfig-uk_UA.KOI8-U.ps" uk_UA.KOI8-U.ps

	dohtml "${WORKDIR}/fig2mpdf/doc/"* || die

	mv "${ED}"/usr/bin/fig2ps2tex{.sh,} || die #338295

	dodoc README CHANGES LATEX.AND.XFIG NOTES
}

pkg_postinst() {
	elog "Note, that defaults are changed and now if you don't want to ship"
	elog "personal information into output files, use fig2dev with -a option."
}
