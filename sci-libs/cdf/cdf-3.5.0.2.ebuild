# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/cdf/cdf-3.5.0.2.ebuild,v 1.1 2015/04/03 14:22:51 jlec Exp $

EAPI=5

inherit eutils java-pkg-opt-2 multilib toolchain-funcs versionator

MY_DP="${PN}$(get_version_component_range 1)$(get_version_component_range 2)"
MY_P="${MY_DP}_$(get_version_component_range 3)"

DESCRIPTION="Common Data Format I/O library for multi-dimensional data sets"
HOMEPAGE="http://cdf.gsfc.nasa.gov/"
SRC_BASE="http://cdaweb.gsfc.nasa.gov/pub/software/${PN}/dist/${MY_P}/unix/"

SRC_URI="${SRC_BASE}/${MY_P}-dist-${PN}.tar.gz
	java? ( ${SRC_BASE}/${MY_P}-dist-java.tar.gz )
	doc? (
		${SRC_BASE}/${MY_DP}_documentation/${MY_DP}0crm.pdf
		${SRC_BASE}/${MY_DP}_documentation/${MY_DP}0frm.pdf
		${SRC_BASE}/${MY_DP}_documentation/${MY_DP}ifd.pdf
		${SRC_BASE}/${MY_DP}_documentation/${MY_DP}0prm.pdf
		${SRC_BASE}/${MY_DP}_documentation/${MY_DP}0ug.pdf
		java? ( ${SRC_BASE}/${MY_DP}_documentation/${MY_DP}0jrm.pdf )
	)"

LICENSE="CDF"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples java ncurses static-libs"

RDEPEND="
	java? ( >=virtual/jre-1.5 )
	ncurses? ( sys-libs/ncurses )
	"
DEPEND="
	java? ( >=virtual/jdk-1.5 )
	ncurses? ( sys-libs/ncurses )
	"

S="${WORKDIR}/${MY_P}-dist"

src_prepare() {
	# respect cflags, remove useless scripts
	epatch \
		"${FILESDIR}"/${P}-Makefile.patch \
		"${FILESDIR}"/${PN}-3.2-soname.patch
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
		insinto /usr/share/doc/${PF}
		doins "${DISTDIR}"/${MY_DP}*.pdf
		use java || rm "${D}"/usr/share/doc/${PF}/${MY_P}jrm.pdf
	fi

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins samples/*
	fi

	if use java; then
		cd cdfjava || die
		dolib.so jni/libcdfNativeLibrary.so.${PV_SO}
		dosym libcdfNativeLibrary.so.${PV_SO} \
			/usr/$(get_libdir)/libcdfNativeLibrary.so
		java-pkg_dojar */*.jar
		if use examples; then
			insinto /usr/share/doc/${PF}/examples/java
			doins examples/*
		fi
	fi
}
