# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit autotools flag-o-matic java-pkg-opt-2 multilib-minimal python-single-r1 virtualx

DESCRIPTION="Library and tools for reading barcodes from images or video"
HOMEPAGE="https://github.com/mchehab/zbar"
SRC_URI="https://github.com/mchehab/zbar/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86"

IUSE="dbus graphicsmagick gtk +imagemagick introspection java jpeg nls python qt5 static-libs test +threads v4l X xv"
REQUIRED_USE="
	introspection? ( gtk )
	python? ( ${PYTHON_REQUIRED_USE} )
	test? (
		${PYTHON_REQUIRED_USE}
		X? ( imagemagick )
	)
	xv? ( X )"

RESTRICT="!test? ( test )"

COMMON_DEPEND="
	dbus? ( sys-apps/dbus[${MULTILIB_USEDEP}] )
	gtk? (
		dev-libs/glib:2[${MULTILIB_USEDEP}]
		x11-libs/gtk+:3[${MULTILIB_USEDEP}]
		introspection? ( dev-libs/gobject-introspection )
	)
	imagemagick? (
		!graphicsmagick? ( media-gfx/imagemagick:=[png,jpeg?] )
		graphicsmagick? ( media-gfx/graphicsmagick:=[png,jpeg?] )
	)
	jpeg? ( virtual/jpeg:0[${MULTILIB_USEDEP}] )
	python? ( ${PYTHON_DEPS} )
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
		dev-qt/qtx11extras:5
	)
	v4l? ( media-libs/libv4l:0=[${MULTILIB_USEDEP}] )
	X? (
		x11-libs/libX11[${MULTILIB_USEDEP}]
		x11-libs/libXext[${MULTILIB_USEDEP}]
		xv? ( x11-libs/libXv[${MULTILIB_USEDEP}] )
	)"

RDEPEND="${COMMON_DEPEND}
	java? ( >=virtual/jre-1.8 )"

DEPEND="${COMMON_DEPEND}
	java? (
		>=virtual/jdk-1.8
		test? (
			dev-java/hamcrest-core:1.3
			dev-java/junit:4
		)
	)
	test? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			dev-python/pillow[${PYTHON_MULTI_USEDEP}]
		')
	)"

BDEPEND="
	app-text/xmlto
	virtual/pkgconfig
	gtk? ( dev-util/glib-utils )
	nls? (
		sys-devel/gettext
		virtual/libiconv
	)"

PATCHES=(
	"${FILESDIR}/${P}_fix_leftover_on_shell_compatibility.patch"
	"${FILESDIR}/${P}_fix_unittest.patch"
	"${FILESDIR}/zbar-0.23_fix_Qt5X11Extras_detect.patch"
	"${FILESDIR}/zbar-0.23_fix_python_detect.patch"
)

DOCS=( README.md NEWS.md TODO.md HACKING.md TODO.md ChangeLog )

pkg_setup() {
	if use python || use test; then
		python-single-r1_pkg_setup
	fi
	use java && java-pkg-opt-2_pkg_setup
}

src_prepare() {
	default

	if use python || use test; then
		if use test; then
			# make tests happy
			# because one of the test requires loadable py module from the current ${BUILD_DIR}
			sed -e "s|PYTHONPATH=@abs_top_srcdir@|PYTHONPATH=@builddir@|g" \
				-i test/Makefile.am.inc || die
		fi

		python_fix_shebang \
			examples/*.py \
			test/{test_python,barcodetest}.py # test_pygtk.py — py2 only
	fi

	if use java; then
		java-pkg-opt-2_src_prepare
		sed -e "s|javadir = \$(pkgdatadir)|javadir = /usr/$(get_libdir)/zbar|" \
			-i java/Makefile.am || die
	fi

	# do not install {LICENSE,INSTALL,etc} doc files with 'make install' (use DOCS=() instead)
	sed -e "s|^dist_doc_DATA =\(.*\)|dist_doc_DATA =|" -i Makefile.am || die

	eautoreconf
}

multilib_src_configure() {
	append-cppflags -DNDEBUG

	local myeconfargs=(
		$(use_with dbus)
		$(use_with gtk gtk gtk3) # default is gtk2
		$(use_with jpeg)
		$(multilib_native_use_with introspection gir)
		$(multilib_native_use_with java)
		$(multilib_native_use_with python python auto)
		$(use_enable nls)
		$(use_enable static-libs static)
		$(use_enable threads pthread)
		$(use_enable v4l video)
		$(use_with X x)
		$(use_with X xshm)
		$(use_with xv xv)
	)

	if multilib_is_native_abi; then
		# both must be enabled to use GraphicsMagick
		if use graphicsmagick; then
			myeconfargs+=(
				--with-graphicsmagick
				--without-imagemagick
			)
		elif use imagemagick; then
			myeconfargs+=(
				--with-imagemagick
				--without-graphicsmagick
			)
		else
			myeconfargs+=(
				--without-imagemagick
				--without-graphicsmagick
			)
		fi

		if use java; then
			export JAVACFLAGS="$(java-pkg_javac-args)"
			append-cflags "$(java-pkg_get-jni-cflags)"
			if use test; then # bug 629078
				myeconfargs+=( --with-java-unit )
				java-pkg_append_ CLASSPATH .
				java-pkg_append_ CLASSPATH $(java-pkg_getjar --build-only junit-4 junit.jar)
				java-pkg_append_ CLASSPATH $(java-pkg_getjar --build-only hamcrest-core-1.3 hamcrest-core.jar)
			fi
		fi

		if use qt5; then
			myeconfargs+=(
				--with-qt
				--with-qt5
			)
		else
			myeconfargs+=( --without-qt )
		fi
	else
		myeconfargs+=(
			--without-graphicsmagick
			--without-imagemagick
			--without-qt
		)

		# zbarimg tests with native abi only
		# (this option from the patch above, stay up to date)
		use test && myeconfargs+=( --without-zbarimg-tests )
	fi

	# use bash (bug 721370)
	CONFIG_SHELL='/bin/bash' \
	ECONF_SOURCE="${S}" \
		econf "${myeconfargs[@]}"

	# work around out-of-source build issues for multilib systems (bug 672184)
	mkdir qt zbarcam || die
}

src_test() {
	virtx multilib-minimal_src_test
}

src_install() {
	if use qt5; then
		local MULTILIB_WRAPPED_HEADERS=(
			/usr/include/zbar/QZBar.h
			/usr/include/zbar/QZBarImage.h
		)
	fi
	multilib-minimal_src_install
}

multilib_src_install_all() {
	einstalldocs
	find "${D}" -name '*.la' -delete || die
}

pkg_preinst() {
	use java && java-pkg-opt-2_pkg_preinst
}
