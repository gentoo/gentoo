# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic multilib-minimal xdg

DESCRIPTION="C++ user interface toolkit for X and OpenGL"
HOMEPAGE="https://www.fltk.org/"
SRC_URI="https://www.fltk.org/pub/${PN}/${PV}/${P}-source.tar.gz"

LICENSE="FLTK LGPL-2"
SLOT="1"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~sparc x86"
IUSE="cairo debug doc examples games +opengl static-libs +threads +xft +xinerama"

RDEPEND="
	media-libs/libjpeg-turbo:0=[${MULTILIB_USEDEP}]
	>=media-libs/libpng-1.2:0=[${MULTILIB_USEDEP}]
	virtual/zlib:=[${MULTILIB_USEDEP}]
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
	virtual/pkgconfig
	x11-base/xorg-proto
	doc? ( app-text/doxygen )
"
DOCS=(
	ANNOUNCEMENT
	CHANGES
	CHANGES_1.0
	CHANGES_1.1
	CREDITS
	README
	README.abi-version.txt
	README.Cairo.txt
	README.CMake.txt
	README.MSWindows.txt
	README.OSX.txt
	README.Unix.txt
)
FLTK_GAMES="
	blocks
	checkers
	sudoku
"
PATCHES=(
	"${FILESDIR}"/${PN}-1.3.0-share.patch
	"${FILESDIR}"/${PN}-1.3.4-conf-tests.patch
	"${FILESDIR}"/${PN}-1.3.3-makefile-dirs.patch
	"${FILESDIR}"/${PN}-1.3.3-visibility.patch
)

pkg_setup() {
	unset FLTK_LIBDIRS
}

src_prepare() {
	default

	rm -rf zlib jpeg png || die

	sed -i \
		-e 's:@HLINKS@::g' FL/Makefile.in || die
	sed -i \
		-e '/x-fluid/d' fluid/Makefile || die
	sed -i \
		-e '/C\(XX\)\?FLAGS=/s:@C\(XX\)\?FLAGS@::' \
		-e '/^LDFLAGS=/d' \
		"${S}/fltk-config.in" || die
	# docs in proper docdir
	sed -i \
		-e "/^docdir/s:fltk:${PF}/html:" \
		-e "/SILENT:/d" \
		makeinclude.in || die

	# also in Makefile:config.guess config.sub:
	cp misc/config.{guess,sub} . || die

	cp fluid/{,x-}fluid.desktop || die

	eaclocal
	eautoconf
	multilib_copy_sources
}

multilib_src_configure() {
	# -Werror=odr
	# https://bugs.gentoo.org/881107
	# Seems to be fixed in git (1.4.9999)
	filter-lto

	unset FLTK_LIBDIRS

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
		--libdir=${FLTK_LIBDIR} \
		DSOFLAGS="${LDFLAGS}" \
		LDFLAGS="${LDFLAGS}"
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
		emake -C fluid DESTDIR="${D}" install-linux install

		use doc && \
			emake -C documentation DESTDIR="${D}" install

		use games && \
			emake -C test DESTDIR="${D}" install-linux
	fi
}

multilib_src_install_all() {
	for app in fluid $(usex games "${FLTK_GAMES}" ''); do
		dosym \
			../icons/hicolor/32x32/apps/${app}.png \
			/usr/share/pixmaps/${app}.png
	done

	if use examples; then
		docinto examples
		dodoc -r test/*.{h,cxx,fl} test/demo.menu
	fi

	insinto /usr/share/cmake/Modules
	doins CMake/FLTK*.cmake

	newenvd - 99fltk <<- _EOF_
		LDPATH="${FLTK_LIBDIRS}"
		FLTK_DOCDIR="${EPREFIX}"/usr/share/doc/"${PF}"/html
	_EOF_

	# FIXME: This is bad, but building only shared libraries is hardly supported
	# FIXME: The executables in test/ are linking statically against libfltk
	if ! use static-libs; then
		rm "${ED}"/usr/lib*/fltk/*.a || die
	fi

	find "${D}" -name '*.la' -delete || die
}
