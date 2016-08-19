# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools eutils fdo-mime flag-o-matic

DESCRIPTION="C++ user interface toolkit for X and OpenGL"
HOMEPAGE="http://www.fltk.org/"
SRC_URI="http://fltk.org/pub/${PN}/${PV}/${P}-source.tar.gz"

SLOT="1"
LICENSE="FLTK LGPL-2"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~x86-macos"
IUSE="cairo debug doc examples games +opengl static-libs +threads +xft +xinerama"

RDEPEND="
	>=media-libs/libpng-1.2:0
	sys-libs/zlib
	virtual/jpeg:0
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libXext
	x11-libs/libXt
	cairo? ( x11-libs/cairo )
	opengl? ( virtual/glu virtual/opengl )
	xft? ( x11-libs/libXft )
	xinerama? ( x11-libs/libXinerama )
"
DEPEND="
	${RDEPEND}
	x11-proto/xextproto
	doc? ( app-doc/doxygen )
	xinerama? ( x11-proto/xineramaproto )
"

src_prepare() {
	rm -rf zlib jpeg png || die
	epatch \
		"${FILESDIR}"/${PN}-1.3.2-desktop.patch \
		"${FILESDIR}"/${PN}-1.3.0-share.patch \
		"${FILESDIR}"/${PN}-1.3.2-conf-tests.patch \
		"${FILESDIR}"/${PN}-1.3.2-jpeg-9a.patch \
		"${FILESDIR}"/${PN}-1.3.3-visibility.patch \
		"${FILESDIR}"/${PN}-1.3.3-fl_open_display.patch \
		"${FILESDIR}"/${PN}-1.3.3-fltk-config.patch \
		"${FILESDIR}"/${PN}-1.3.3-xutf8-visibility.patch

	sed -i \
		-e 's:@HLINKS@::g' FL/Makefile.in || die
	# some fixes introduced because slotting
	sed -i \
		-e '/RANLIB/s:$(libdir)/\(.*LIBNAME)\):$(libdir)/`basename \1`:g' \
		src/Makefile || die
	# docs in proper docdir
	sed -i \
		-e "/^docdir/s:fltk:${PF}/html:" \
		-e "/SILENT:/d" \
		makeinclude.in || die
	sed -e "s/7/${PV}/" \
		< "${FILESDIR}"/FLTKConfig.cmake \
		> CMake/FLTKConfig.cmake || die
	sed -e 's:-Os::g' -i configure.in || die

	use prefix && append-ldflags -Wl,-rpath -Wl,"${FLTK_LIBDIR}"

	# also in Makefile:config.guess config.sub:
	cp misc/config.{guess,sub} . || die

	eautoconf
}

src_configure() {
	FLTK_INCDIR=${EPREFIX}/usr/include/fltk
	FLTK_LIBDIR=${EPREFIX}/usr/$(get_libdir)/fltk

	econf \
		$(use_enable cairo) \
		$(use_enable debug) \
		$(use_enable opengl gl) \
		$(use_enable threads) \
		$(use_enable xft) \
		$(use_enable xinerama) \
		--disable-localjpeg \
		--disable-localpng \
		--disable-localzlib \
		--docdir="${EPREFIX}/usr/share/doc/${PF}/html" \
		--enable-largefile \
		--enable-shared \
		--enable-xdbe \
		--includedir=${FLTK_INCDIR} \
		--libdir=${FLTK_LIBDIR}
}

src_compile() {
	default

	if use doc; then
		emake -C documentation html
	fi

	if use games; then
		emake -C test blocks checkers sudoku
	fi
}

src_test() {
	emake -C test
}

src_install() {
	default

	emake -C fluid \
			DESTDIR="${D}" install-linux
	if use doc; then
		emake -C documentation \
			DESTDIR="${D}" install
	fi

	local apps="fluid"
	if use games; then
		emake -C test \
			DESTDIR="${D}" install-linux
		emake -C documentation \
			DESTDIR="${D}" install-linux
		apps+=" sudoku blocks checkers"
	fi

	for app in ${apps}; do
		dosym /usr/share/icons/hicolor/32x32/apps/${app}.png \
			/usr/share/pixmaps/${app}.png
	done

	dodoc CHANGES README CREDITS ANNOUNCEMENT

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins test/*.{h,cxx,fl} test/demo.menu
	fi

	insinto /usr/share/cmake/Modules
	doins CMake/FLTK*.cmake

	echo "LDPATH=${FLTK_LIBDIR}" > 99fltk
	echo "FLTK_DOCDIR=${EPREFIX}/usr/share/doc/${PF}/html" >> 99fltk
	doenvd 99fltk

	# FIXME: This is bad, but building only shared libraries is hardly supported
	# FIXME: The executables in test/ are linking statically against libfltk
	if ! use static-libs; then
		rm "${ED}"/usr/lib*/fltk/*.a || die
	fi

	prune_libtool_files
}

pkg_postinst() {
	fdo-mime_desktop_database_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
}
