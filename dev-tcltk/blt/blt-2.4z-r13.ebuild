# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tcltk/blt/blt-2.4z-r13.ebuild,v 1.5 2015/08/02 18:54:47 ago Exp $

EAPI=5

inherit autotools eutils flag-o-matic multilib toolchain-funcs

MY_V_SUFFIX="-8.5.2"

DESCRIPTION="Extension to Tk, adding new widgets, geometry managers, and misc commands"
HOMEPAGE="
	http://blt.sourceforge.net/
	http://jos.decoster.googlepages.com/bltfortk8.5.2"
SRC_URI="
	http://dev.gentoo.org/~jlec/distfiles/${PN}${PV}${MY_V_SUFFIX}.tar.gz
	http://jos.decoster.googlepages.com/${PN}${PV}${MY_V_SUFFIX}.tar.gz"

IUSE="jpeg static-libs X"
SLOT="0"
LICENSE="BSD"
KEYWORDS="alpha amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

DEPEND="
	dev-lang/tk:0=
	jpeg? ( virtual/jpeg:0= )
	X? ( x11-libs/libX11 )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}${PV}${MY_V_SUFFIX}"

MAKEOPTS+=" -j1"

src_prepare() {
	epatch "${FILESDIR}/blt-2.4z-r4-fix-makefile2.patch"
	epatch "${FILESDIR}/blt-2.4z-r4-fix-makefile3.patch"
	# From blt-2.4z-6mdk.src.rpm
	epatch "${FILESDIR}"/blt2.4z-64bit.patch

	epatch "${FILESDIR}"/blt-2.4z-tcl8.5-fixpkgruntime.patch

	epatch "${FILESDIR}"/${P}-ldflags.patch

	# Set the correct libdir and drop RPATH
	sed \
		-e "s:\(^libdir=\${exec_prefix}/\)lib:\1$(get_libdir):" \
		-e 's:LD_RUN_PATH=.*$:LD_RUN_PATH="":g' \
		-e "/RANLIB/s:ranlib:$(tc-getRANLIB):g" \
		-i configure* || die "sed configure* failed"
	sed \
		-e "/^scriptdir =/s:lib:$(get_libdir):" \
		-i Makefile.in demos/Makefile.in || die "sed Makefile.in failed"

	sed \
		-e "/AR/s:ar:$(tc-getAR):g" \
		-e 's:0444:0644:g' \
		-i src/Makefile.in || die

	epatch \
		"${FILESDIR}"/${P}-linking.patch \
		"${FILESDIR}"/${P}-darwin.patch \
		"${FILESDIR}"/${P}-gbsd.patch \
		"${FILESDIR}"/${P}-tk8.6.patch \
		"${FILESDIR}"/${P}-tcl8.6.patch \
		"${FILESDIR}"/${P}-aclocal.patch

	append-cflags -fPIC

	mv configure.{in,ac} || die

	eautoreconf
}

src_configure() {
	LC_ALL=C \
	econf \
		--x-includes="${EPREFIX}/usr/include" \
		--x-libraries="${EPREFIX}/usr/$(get_libdir)" \
		--with-blt="${EPREFIX}/usr/$(get_libdir)" \
		--with-tcl="${EPREFIX}/usr/$(get_libdir)" \
		--with-tk="${EPREFIX}/usr/$(get_libdir)" \
		--with-tclincls="${EPREFIX}/usr/include" \
		--with-tkincls="${EPREFIX}/usr/include" \
		--with-tcllibs="${EPREFIX}/usr/$(get_libdir)" \
		--with-tklibs="${EPREFIX}/usr/$(get_libdir)" \
		--with-cc="$(tc-getCC)" \
		--with-cflags="${CFLAGS}" \
		--with-gnu-ld \
		$(use_enable jpeg) \
		$(use_with X x)
}

src_compile() {
	emake LDFLAGS="${LDFLAGS}"
}

src_install() {
	sed \
		-e "s:\.\./src/bltwish:${EPREFIX}/usr/bin/bltwish:g" \
		-e "s:\.\./bltwish:${EPREFIX}/usr/bin/bltwish:g" \
		-e "s:/usr/local/bin/bltwish:${EPREFIX}/usr/bin/bltwish:g" \
		-e "s:/usr/local/bin/tclsh:${EPREFIX}/usr/bin/tclsh:g" \
		-i demos/{,scripts/}*.tcl || die

	dodir \
		/usr/bin \
		/usr/$(get_libdir)/blt2.4/demos/bitmaps \
		/usr/share/man/mann \
		/usr/include

	emake INSTALL_ROOT="${D}" install

	dodoc NEWS PROBLEMS README
	dohtml html/*.html
	for f in `ls "${ED}"/usr/share/man/mann` ; do
		mv "${ED}"/usr/share/man/mann/${f} "${ED}"/usr/share/man/mann/${f/.n/.nblt} || die
	done

	# fix for linking against shared lib with -lBLT or -lBLTlite
	dosym libBLT24$(get_libname) /usr/$(get_libdir)/libBLT$(get_libname)
	dosym libBLTlite24$(get_libname) /usr/$(get_libdir)/libBLTlite$(get_libname)

	use static-libs || \
		find "${ED}"/usr/$(get_libdir) -name "*.a" -print0 | \
		xargs -r -0 rm -fv
}
