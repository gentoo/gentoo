# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit fortran-2 flag-o-matic toolchain-funcs

MY_P="${PN}${PV//.}"

DESCRIPTION="FORTRAN/C device-independent scientific graphic library"
HOMEPAGE="https://www.astro.caltech.edu/~tjp/pgplot/"
SRC_URI="ftp://ftp.astro.caltech.edu/pub/pgplot/${MY_P}.tar.gz"

SLOT="0"
LICENSE="free-noncomm"
KEYWORDS="amd64 ~arm ~ia64 ~ppc x86 ~amd64-linux ~x86-linux"
IUSE="doc motif static-libs tk"

RDEPEND="
	media-libs/libpng:=
	x11-libs/libX11:=
	x11-libs/libXt:=
	motif? ( x11-libs/motif:= )
	tk? ( dev-lang/tk:= )"
DEPEND="${RDEPEND}
	doc? ( virtual/latex-base )"

S="${WORKDIR}/${PN}"

PATCHES=(
	"${FILESDIR}"/${PN}-drivers.patch
	"${FILESDIR}"/${PN}-makemake.patch
	"${FILESDIR}"/${PN}-compile-setup.patch
	"${FILESDIR}"/${PN}-headers.patch
	"${FILESDIR}"/${PN}-libpng15.patch
	"${FILESDIR}"/${PN}-tk86.patch
)

src_prepare() {
	default

	# fix pointers for 64 bits
	if use amd64 || use ia64; then
		sed -e 's/INTEGER PIXMAP/INTEGER*8 PIXMAP/g' \
			-i drivers/{gi,pp,wd}driv.f || die "sed 64bits failed"
	fi

	cp sys_linux/g77_gcc.conf local.conf

	sed -e "s:FCOMPL=.*:FCOMPL=\"$(tc-getFC)\":g" \
		-e "s:CCOMPL=.*:CCOMPL=\"$(tc-getCC)\":g" \
		-i local.conf || die "sed flags failed"

	if [[ "$(tc-getFC)" = if* ]]; then
		sed -e 's/-Wall//g' \
			-e 's/TK_LIBS="/TK_LIBS="-nofor-main /' \
			-i local.conf || die "sed drivers failed"
	fi

	sed -e "s:/usr/local/pgplot:${EPREFIX}/usr/$(get_libdir)/pgplot:g" \
		-e "s:/usr/local/bin:${EPREFIX}/usr/bin:g" \
		-i src/grgfil.f makehtml maketex || die "sed path failed"

	use motif && sed -i -e '/XMDRIV/s/!//' drivers.list
	use tk && sed -i -e '/TKDRIV/s/!//' drivers.list
}

src_configure() {
	# GCC 10 workaround
	# bug #722190
	append-fflags $(test-flags-FC -fallow-argument-mismatch)

	./makemake . linux
	# post makefile creation prefix hack
	sed -i -e "s|/usr|${EPREFIX}/usr|g" makefile || die
}

src_compile() {
	emake \
		CFLAGS="${CFLAGS} -fPIC" \
		FFLAGS="${FFLAGS} -fPIC" \
		shared cpg-shared pgxwin_server pgdisp pgplot.doc

	use tk && emake CFLAGS="${CFLAGS} -fPIC" libtkpgplot.so
	use motif && emake CFLAGS="${CFLAGS} -fPIC" libXmPgplot.so

	emake -j1 clean
	use static-libs && emake all cpg

	if use doc; then
		export VARTEXFONTS="${T}/fonts"
		emake pgplot.html pgplot-routines.tex
		pdflatex pgplot-routines.tex
		pdflatex pgplot-routines.tex
	fi

	# this just cleans out not needed files
	emake -j1 clean
}

src_test() {
	# i can go to 16
	local i j
	for i in 1 2 3; do
		emake pgdemo${i}
		# j can also be LATEX CPS...
		for j in NULL PNG PS CPS LATEX; do
			local testexe=./test_${j}_${i}
			echo "LD_LIBRARY_PATH=. ./pgdemo${i} <<EOF" > ${testexe}
			echo "/${j}" >> ${testexe}
			echo "EOF" >> ${testexe}
			sh ${testexe} || die "test ${i} failed"
		done
	done
}

src_install() {
	insinto /usr/$(get_libdir)/pgplot
	doins grfont.dat grexec.f *.inc rgb.txt
	echo "PGPLOT_FONT=${EPREFIX}/usr/$(get_libdir)/pgplot/grfont.dat" >> 99pgplot
	doenvd 99pgplot

	dolib.so libpgplot.so*
	dobin pgxwin_server pgdisp

	# C binding
	insinto /usr/include
	doins cpgplot.h
	dolib.so libcpgplot.so*

	if use motif; then
		insinto /usr/include
		doins XmPgplot.h
		dolib.so libXmPgplot.so*
	fi

	if use tk; then
		insinto /usr/include
		doins tkpgplot.h
		dolib.so libtkpgplot.so*
	fi

	use static-libs && dolib.a lib*pgplot.a

	# minimal doc
	dodoc aaaread.me pgplot.doc
	newdoc pgdispd/aaaread.me pgdispd.txt

	if use doc; then
		dodoc cpg/cpgplot.doc applications/curvefit/curvefit.doc pgplot.html
		dodoc pgplot-routines.pdf pgplot-routines.tex
		docinto examples
		dodoc -r examples/. cpg/cpgdemo.c
		docompress -x /usr/share/doc/${PF}/examples
		dodoc -r applications
		docompress -x /usr/share/doc/${PF}/applications
		if use motif; then
			docinto pgm
			dodoc -r pgmf/. drivers/xmotif/pgmdemo.c
			docompress -x /usr/share/doc/${PF}/pgm
		fi
		if use tk; then
			docinto pgtk
			dodoc drivers/xtk/pgtkdemo.*
			docompress -x /usr/share/doc/${PF}/pgtk
		fi
	fi
}
