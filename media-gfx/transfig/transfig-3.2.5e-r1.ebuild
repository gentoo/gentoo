# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

MY_P="${PN}.${PV}"

DESCRIPTION="Set of tools for creating TeX documents with graphics"
HOMEPAGE="https://www.xfig.org/"
SRC_URI="mirror://sourceforge/mcj/${MY_P}.tar.gz
	mirror://gentoo/fig2mpdf-1.1.2.tar.bz2
	https://dev.gentoo.org/~sultan/distfiles/media-gfx/transfig/${P}-gentoo-patchset-r1.tar.bz2"
S="${WORKDIR}/${MY_P}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris ~x86-solaris"

RDEPEND="
	media-libs/libpng
	virtual/jpeg
	x11-apps/rgb
	x11-libs/libXpm"
DEPEND="${RDEPEND}"
BDEPEND="
	app-text/rman
	sys-devel/gcc
	>=x11-misc/imake-1.0.8-r1"

PATCHES=(
	"${WORKDIR}/${P}-gentoo-patchset/${PN}-3.2.5d-fig2mpdf-r1.patch"
	"${WORKDIR}/${P}-gentoo-patchset/${PN}-3.2.5c-maxfontsize.patch"
	"${WORKDIR}/${P}-gentoo-patchset/${PN}-3.2.5-solaris.patch"
	"${WORKDIR}/${P}-gentoo-patchset/${PN}-3.2.5e-typos.patch"
	"${WORKDIR}/${P}-gentoo-patchset/${PN}-3.2.5e-man-hyphen.patch"
	"${WORKDIR}/${P}-gentoo-patchset/${PN}-3.2.5e-fprintf_format_warnings.patch"
	"${FILESDIR}/${PN}-3.2.5e-gcc10-fno-common.patch"
	"${FILESDIR}/${PN}-3.2.5e-clang.patch"
)

DOCS=( README CHANGES LATEX.AND.XFIG NOTES )
HTML_DOCS=( "${WORKDIR}/fig2mpdf/doc/." )

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
		sed -i "s:^\(XCOMM\)*[[:space:]]*${varname}[[:space:]]*=.*$:${varname} = ${varval}:" "$@" || die
	done
}

src_prepare() {
	default

	find . -type f -exec chmod a-x '{}' \; || die
	find . -name Makefile -delete || die

	sed -e 's:-L$(ZLIBDIR) -lz::' \
		-e 's: -lX11::' \
			-i fig2dev/Imakefile || die
	sed_Imakefile fig2dev/Imakefile fig2dev/dev/Imakefile
}

src_configure() {
	export IMAKECPP=${IMAKECPP:-${CHOST}-gcc -E}
	CC="$(tc-getBUILD_CC)" LD="$(tc-getLD)" xmkmf || die
}

src_compile() {
	emake CC="$(tc-getBUILD_CC)" LD="$(tc-getLD)" Makefiles

	local myemakeargs=(
		CC="$(tc-getCC)"
		AR="$(tc-getAR) cq"
		RANLIB="$(tc-getRANLIB)"
		CDEBUGFLAGS="${CFLAGS}"
		LOCAL_LDFLAGS="${LDFLAGS}"
		USRLIBDIR="${EPREFIX}/usr/$(get_libdir)"
	)
	emake "${myemakeargs[@]}"
}

src_install() {
	local myemakeargs=(
		DESTDIR="${D}"
		INSTDATFLAGS="-m 644"
		INSTMANFLAGS="-m 644"
	)
	emake "${myemakeargs[@]}" install install.man

	dobin "${WORKDIR}/fig2mpdf/fig2mpdf"
	doman "${WORKDIR}/fig2mpdf/fig2mpdf.1"

	insinto /usr/share/fig2dev/
	newins "${WORKDIR}/${P}-gentoo-patchset/transfig-ru_RU.CP1251.ps" ru_RU.CP1251.ps
	newins "${WORKDIR}/${P}-gentoo-patchset/transfig-ru_RU.KOI8-R.ps" ru_RU.KOI8-R.ps
	newins "${WORKDIR}/${P}-gentoo-patchset/transfig-uk_UA.KOI8-U.ps" uk_UA.KOI8-U.ps

	einstalldocs

	rm "${ED}/usr/share/doc/${PF}/html/"{Makefile,*.lfig,*.pdf,*.tex} || die

	mv "${ED}"/usr/bin/fig2ps2tex{.sh,} || die #338295
}

pkg_postinst() {
	elog "Note, that defaults are changed and now if you don't want to ship"
	elog "personal information into output files, use fig2dev with -a option."
}
