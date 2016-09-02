# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit autotools fdo-mime flag-o-matic multilib-minimal

DESCRIPTION="C++ user interface toolkit for X and OpenGL"
HOMEPAGE="http://www.fltk.org/"
SRC_URI="http://fltk.org/pub/${PN}/${PV}/${P}-source.tar.gz"

SLOT="1"
LICENSE="FLTK LGPL-2"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~x86-macos"
IUSE="cairo debug doc examples games +opengl static-libs +threads +xft +xinerama"

RDEPEND="
	>=media-libs/libpng-1.2:0=[${MULTILIB_USEDEP}]
	sys-libs/zlib[${MULTILIB_USEDEP}]
	virtual/jpeg:0=[${MULTILIB_USEDEP}]
	x11-libs/libICE[${MULTILIB_USEDEP}]
	x11-libs/libSM[${MULTILIB_USEDEP}]
	x11-libs/libXcursor[${MULTILIB_USEDEP}]
	x11-libs/libXext[${MULTILIB_USEDEP}]
	x11-libs/libXfixes[${MULTILIB_USEDEP}]
	x11-libs/libXt[${MULTILIB_USEDEP}]
	cairo? ( x11-libs/cairo[${MULTILIB_USEDEP},X] )
	opengl? (
		virtual/glu[${MULTILIB_USEDEP}]
		virtual/opengl[${MULTILIB_USEDEP}]
	)
	xft? ( x11-libs/libXft[${MULTILIB_USEDEP}] )
	xinerama? ( x11-libs/libXinerama[${MULTILIB_USEDEP}] )
"
DEPEND="
	${RDEPEND}
	x11-proto/xextproto
	doc? ( app-doc/doxygen )
	xinerama? ( x11-proto/xineramaproto )
"

DOCS=(
	ANNOUNCEMENT
	CHANGES
	CREDITS
	README
)
FLTK_GAMES="
	blocks
	checkers
	sudoku
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.3.0-share.patch
	"${FILESDIR}"/${PN}-1.3.2-conf-tests.patch
	"${FILESDIR}"/${PN}-1.3.2-desktop.patch
	"${FILESDIR}"/${PN}-1.3.2-jpeg-9a.patch
	"${FILESDIR}"/${PN}-1.3.3-fl_open_display.patch
	"${FILESDIR}"/${PN}-1.3.3-fltk-config.patch
	"${FILESDIR}"/${PN}-1.3.3-makefile-dirs.patch
	"${FILESDIR}"/${PN}-1.3.3-visibility.patch
	"${FILESDIR}"/${PN}-1.3.3-xutf8-visibility.patch
)

pkg_setup() {
	unset FLTK_LIBDIRS
}

src_prepare() {
	default

	rm -rf zlib jpeg png || die

	sed -i \
		-e 's:@HLINKS@::g' FL/Makefile.in || die
	# docs in proper docdir
	sed -i \
		-e "/^docdir/s:fltk:${PF}/html:" \
		-e "/SILENT:/d" \
		makeinclude.in || die
	sed -e "s/7/${PV}/" \
		< "${FILESDIR}"/FLTKConfig.cmake \
		> CMake/FLTKConfig.cmake || die
	sed -e 's:-Os::g' -i configure.in || die

	# also in Makefile:config.guess config.sub:
	cp misc/config.{guess,sub} . || die

	eautoconf
	multilib_copy_sources
}

multilib_src_configure() {
	local FLTK_INCDIR=${EPREFIX}/usr/include/fltk
	local FLTK_LIBDIR=${EPREFIX}/usr/$(get_libdir)/fltk
	FLTK_LIBDIRS+=${FLTK_LIBDIRS+:}${FLTK_LIBDIR}

	multilib_is_native_abi && use prefix &&
		append-ldflags -Wl,-rpath -Wl,"${FLTK_LIBDIR}"

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
		--enable-xcursor \
		--enable-xdbe \
		--enable-xfixes \
		--includedir=${FLTK_INCDIR} \
		--libdir=${FLTK_LIBDIR}
}

multilib_src_compile() {
	# Prevent reconfigure on non-native ABIs.
	touch -r makeinclude config.{guess,sub} || die

	default

	if multilib_is_native_abi; then
		emake -C fluid
		use doc && emake -C documentation html
		use games && emake -C test ${FLTK_GAMES}
	fi
}

multilib_src_test() {
	emake -C fluid
	emake -C test
}

multilib_src_install() {
	default

	if multilib_is_native_abi; then
		emake -C fluid DESTDIR="${D}" install-linux

		use doc && \
			emake -C documentation DESTDIR="${D}" install

		use games && \
			emake -C test DESTDIR="${D}" install-linux
	fi
}

multilib_src_install_all() {
	for app in fluid $(usex games "${FLTK_GAMES}" ''); do
		dosym \
			/usr/share/icons/hicolor/32x32/apps/${app}.png \
			/usr/share/pixmaps/${app}.png
	done

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins test/*.{h,cxx,fl} test/demo.menu
	fi

	insinto /usr/share/cmake/Modules
	doins CMake/FLTK*.cmake

	echo "LDPATH=${FLTK_LIBDIRS}" > 99fltk || die
	echo "FLTK_DOCDIR=${EPREFIX}/usr/share/doc/${PF}/html" >> 99fltk || die
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
