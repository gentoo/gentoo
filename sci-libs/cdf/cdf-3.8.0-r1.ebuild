# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic java-pkg-opt-2 multilib toolchain-funcs

MY_DP="${PN}$(ver_cut 1)$(ver_cut 2)"
MY_P="${MY_DP}_$(ver_cut 3)"

DESCRIPTION="Common Data Format I/O library for multi-dimensional data sets"
HOMEPAGE="https://cdf.gsfc.nasa.gov"
SRC_BASE="https://spdf.gsfc.nasa.gov/pub/software/${PN}/dist/${MY_P}/unix/"

SRC_URI="${SRC_BASE}/${MY_P}-dist-${PN}.tar.gz
	java? ( ${SRC_BASE}/${MY_P}-dist-java.tar.gz )
	doc? (
		${SRC_BASE}/${MY_DP}_documentation/${MY_DP}ifd.pdf
		${SRC_BASE}/${MY_DP}_documentation/${MY_DP}0crm.pdf
		${SRC_BASE}/${MY_DP}_documentation/${MY_DP}0csrm.pdf
		${SRC_BASE}/${MY_DP}_documentation/${MY_DP}0frm.pdf
		${SRC_BASE}/${MY_DP}_documentation/${MY_DP}0prm.pdf
		${SRC_BASE}/${MY_DP}_documentation/${MY_DP}0ug.pdf
		${SRC_BASE}/${MY_DP}_documentation/${MY_DP}0vbrm.pdf
	)"

LICENSE="CDF"
SLOT="0"
KEYWORDS="amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples java ncurses static-libs"
RESTRICT="bindist"

RDEPEND="
	java? ( >=virtual/jre-1.8:= )
	ncurses? ( sys-libs/ncurses:0= )
"
DEPEND="
	${RDEPEND}
	ncurses? ( virtual/pkgconfig )
"

S="${WORKDIR}/${MY_P}-dist"

# respect cflags, ldflags, soname
PATCHES=(
	"${FILESDIR}"/${P}-respect-flags.patch
)

src_prepare() {
	default

	# use proper lib dir
	sed -i \
		-e "s:\$(INSTALLDIR)/lib:\$(INSTALLDIR)/$(get_libdir):g" \
		Makefile || die "sed failed"
}

src_compile() {
	# Reported upstream by email in 2024-03-22 (bug #862675)
	append-flags -fno-strict-aliasing
	filter-lto

	PV_SO=${PV:0:1}
	emake \
		OS=linux \
		AR="$(tc-getAR)" \
		CC="$(tc-getCC)" \
		LD="$(tc-getCC)" \
		ENV=gnu \
		SHARED=yes \
		SHAREDEXT_linux=so.${PV_SO} \
		CURSESLIB_linux_gnu="$(usex ncurses "$($(tc-getPKG_CONFIG) --libs ncurses)" "")" \
		CURSES=$(usex ncurses) \
		${myconf} \
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
	dosym libcdf.so.${PV_SO} /usr/$(get_libdir)/libcdf.so
	use static-libs || rm "${ED}"/usr/$(get_libdir)/libcdf.a
	dodoc Release.notes CHANGES.txt Welcome.txt
	doenvd "${FILESDIR}"/50cdf

	if use doc; then
		dodoc "${DISTDIR}"/${MY_DP}{0{crm,csrm,frm,prm,ug,vbrm},ifd}.pdf
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

	# move this to a better location
	dodir "/usr/share/${PF}"
	mv "${ED}/usr/CDFLeapSeconds.txt" "${ED}/usr/share/${PF}/" || die
}
