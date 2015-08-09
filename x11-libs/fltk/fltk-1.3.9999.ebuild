# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools eutils fdo-mime flag-o-matic subversion

DESCRIPTION="C++ user interface toolkit for X and OpenGL"
HOMEPAGE="http://www.fltk.org/"
ESVN_REPO_URI="http://seriss.com/public/fltk/fltk/branches/branch-1.3/"
ESVN_USER=""
ESVN_PASSWORD=""

SLOT="1"
LICENSE="FLTK LGPL-2"
KEYWORDS=""
IUSE="cairo debug doc examples games +opengl pdf static-libs +threads +xft +xinerama"

RDEPEND="
	>=media-libs/libpng-1.2:0
	virtual/jpeg:0
	sys-libs/zlib
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libXext
	x11-libs/libXt
	cairo? ( x11-libs/cairo )
	opengl? ( virtual/opengl )
	xinerama? ( x11-libs/libXinerama )
	xft? ( x11-libs/libXft )"
DEPEND="${RDEPEND}
	x11-proto/xextproto
	doc? (
		app-doc/doxygen
		pdf? (
			dev-texlive/texlive-fontutils
			dev-texlive/texlive-latex
			dev-texlive/texlive-latexextra
		)
	)
	xinerama? ( x11-proto/xineramaproto )"

FLTK_INCDIR=${EPREFIX}/usr/include/fltk
FLTK_LIBDIR=${EPREFIX}/usr/$(get_libdir)/fltk

src_prepare() {
	rm -rf zlib jpeg png || die
	epatch \
		"${FILESDIR}"/${PN}-1.3.2-desktop.patch \
		"${FILESDIR}"/${PN}-1.3.0-share.patch \
		"${FILESDIR}"/${PN}-1.3.2-conf-tests.patch \
		"${FILESDIR}"/${PN}-1.3.2-jpeg-9a.patch \
		"${FILESDIR}"/${PN}-1.3.3-visibility.patch

	sed -i \
		-e 's:@HLINKS@::g' FL/Makefile.in || die
	sed -i \
		-e '/C\(XX\)\?FLAGS=/s:@C\(XX\)\?FLAGS@::' \
		-e '/^LDFLAGS=/d' \
		"${S}/fltk-config.in" || die
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
	econf \
		--includedir=${FLTK_INCDIR}\
		--libdir=${FLTK_LIBDIR} \
		--docdir="${EPREFIX}/usr/share/doc/${PF}/html" \
		--enable-largefile \
		--enable-shared \
		--enable-xdbe \
		--disable-localjpeg \
		--disable-localpng \
		--disable-localzlib \
		$(use_enable debug) \
		$(use_enable cairo) \
		$(use_enable opengl gl) \
		$(use_enable threads) \
		$(use_enable xft) \
		$(use_enable xinerama)
}

src_compile() {
	default
	if use doc; then
		emake -C documentation html
		if use pdf; then
			emake -C documentation pdf
		fi
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
