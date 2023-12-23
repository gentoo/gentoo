# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

#MY_P="${PN}.${PV}"

DESCRIPTION="Set of tools for creating TeX documents with graphics"
HOMEPAGE="https://www.xfig.org/"
SRC_URI="mirror://sourceforge/mcj/${P}.tar.xz
	mirror://gentoo/fig2mpdf-1.1.2.tar.bz2"
#S="${WORKDIR}/${MY_P}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

RDEPEND="
	media-libs/libpng
	virtual/jpeg
	x11-apps/rgb
	x11-libs/libXpm
	!media-gfx/transfig
"
DEPEND="${RDEPEND}"
BDEPEND="
	app-text/rman
	sys-devel/gcc
"

DOCS=( README CHANGES NOTES )
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

src_configure() {
	# export IMAKECPP=${IMAKECPP:-${CHOST}-gcc -E}
	# CC="$(tc-getBUILD_CC)" LD="$(tc-getLD)" xmkmf || die
	econf --enable-transfig
}

src_compile() {
	# emake CC="$(tc-getBUILD_CC)" LD="$(tc-getLD)" Makefiles

	local myemakeargs=(
		CC="$(tc-getCC)"
		AR="$(tc-getAR)"
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
	emake "${myemakeargs[@]}" install

	dobin "${WORKDIR}/fig2mpdf/fig2mpdf"
	doman "${WORKDIR}/fig2mpdf/fig2mpdf.1"

	einstalldocs

	rm "${ED}/usr/share/doc/${PF}/html/"{Makefile,*.lfig,*.pdf,*.tex} || die
}

pkg_postinst() {
	elog "Note, that defaults are changed and now if you don't want to ship"
	elog "personal information into output files, use fig2dev with -a option."
}
