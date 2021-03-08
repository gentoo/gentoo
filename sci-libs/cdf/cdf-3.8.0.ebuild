# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit java-pkg-opt-2  toolchain-funcs

MY_DP=cdf$(ver_cut 1 )$(ver_cut 2)
MY_P=cdf$(ver_rs 1 '' 2 '_')

DESCRIPTION="Common Data Format I/O library for multi-dimensional data sets"
HOMEPAGE="https://cdf.gsfc.nasa.gov"
SRC_BASE="https://cdaweb.gsfc.nasa.gov/pub/software/cdf/dist/${MY_P}/unix/${MY_DP}_documentation/${MY_DP}"

SRC_URI="https://cdaweb.gsfc.nasa.gov/pub/software/cdf/dist/${MY_P}/unix/${MY_P}-dist-cdf.tar.gz
	java? ( https://cdaweb.gsfc.nasa.gov/pub/software/cdf/dist/${MY_P}/unix/${MY_P}-dist-java.tar.gz )
	doc? (
		${SRC_BASE}0crm.pdf
		${SRC_BASE}0csrm.pdf
		${SRC_BASE}0frm.pdf
		${SRC_BASE}0prm.pdf
		${SRC_BASE}0ug.pdf
		${SRC_BASE}0vbrm.pdf
		${SRC_BASE}ifd.pdf
	)"
	#	Not available in v3.8.0
	#	java? ( ${SRC_BASE}0jrm.pdf )

LICENSE="CDF"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples java ncurses static-libs"

RDEPEND="
	java? ( >=virtual/jre-1.8:= )
	ncurses? ( sys-libs/ncurses:0= )
	"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}-dist"

PATCHES=(
	# reworked from cdf-3.2-soname.patch
	# turns libcdf.3.8.0.so into libcdf.so.3
	"${FILESDIR}"/cdf-3.8.0-soname.patch
	# reworked from cdf-3.5.0.2-Makefile.patch
	# respect cflags, remove useless scripts
	"${FILESDIR}"/cdf-3.8.0-Makefile.patch
)

src_prepare() {
	default
	# use proper lib dir
	sed -i \
		-e "s:\$(INSTALLDIR)/lib:\$(INSTALLDIR)/$(get_libdir):g" \
		Makefile || die "sed failed"
}

src_compile() {
	PV_SO=${PV:0:1}
	emake \
		OS=linux \
		CC=$(tc-getCC) \
		ENV=gnu \
		SHARED=yes \
		SHAREDEXT_linux=so.${PV_SO} \
		CURSESLIB_linux_gnu="$(usex ncurses "$($(tc-getPKG_CONFIG) --libs ncurses)" "")" \
		CURSES=$(usex ncurses) \
		all

	if use java; then
		export CDF_BASE="${S}"
		export CDF_LIB="${S}/src/lib"
		cd cdfjava/jni
		$(tc-getCC) \
			${CFLAGS} -fPIC \
			-I${CDF_BASE}/src/include \
			-I$(java-config -O)/include \
			-I$(java-config -O)/include/linux \
			-c cdfNativeLibrary.c \
			-o cdfNativeLibrary.o \
			|| die "compiling java lib failed"
		$(tc-getCC) \
			${LDFLAGS} \
			-shared cdfNativeLibrary.o \
			-Wl,-soname=libcdfNativeLibrary.so.${PV_SO} \
			-L${CDF_LIB} -lcdf -lm \
			-o libcdfNativeLibrary.so.${PV_SO} \
			|| die "linking java lib failed"
	fi
}

src_test() {
	emake -j1 test
}

src_install() {
	dodir /usr/bin /usr/$(get_libdir)
	# -j1 (fragile non-autotooled make)
	emake -j1 \
		INSTALLDIR="${ED}/usr" \
		SHAREDEXT=so.${PV_SO} \
		install
	use static-libs || rm "${ED}"/usr/$(get_libdir)/libcdf.a
	dodoc Release.notes CHANGES.txt Welcome.txt README_cdf_tools.txt
	doenvd "${FILESDIR}"/50cdf

	if use doc; then
		dodoc "${DISTDIR}"/${MY_DP}{0{crm,csrm,frm,prm,ug,vbrm},ifd}.pdf
		# Not available in v3.8.0
		# use java && dodoc "${DISTDIR}"/${MY_DP}jrm.pdf
	fi

	if use examples; then
		docinto examples
		dodoc samples/*
	fi

	if use java; then
		cd cdfjava || die
		dolib.so jni/libcdfNativeLibrary.so.${PV_SO}
		dosym libcdfNativeLibrary.so.${PV_SO} \
			/usr/$(get_libdir)/libcdfNativeLibrary.so
		java-pkg_dojar */*.jar
		if use examples; then
			docinto examples/java
			dodoc examples/*
		fi
	fi
}
