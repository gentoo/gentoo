# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit autotools flag-o-matic java-pkg-opt-2 multilib-minimal \
	python-single-r1 virtualx

DESCRIPTION="Library and tools for reading barcodes from images or video"
HOMEPAGE="http://zbar.sourceforge.net/"
SRC_URI="https://dev.gentoo.org/~xmw/zbar-0.10_p20121015.zip"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE="gtk imagemagick java jpeg python qt4 static-libs test +threads v4l X xv"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )
	test? ( X ${PYTHON_REQUIRED_USE} )"

CDEPEND="gtk? ( dev-libs/glib:2[${MULTILIB_USEDEP}]
		x11-libs/gtk+:2[${MULTILIB_USEDEP}] )
	imagemagick? ( virtual/imagemagick-tools )
	jpeg? ( virtual/jpeg:0[${MULTILIB_USEDEP}] )
	python? (
		${PYTHON_DEPS}
		gtk? ( >=dev-python/pygtk-2[${PYTHON_USEDEP}] )
	)
	qt4? ( dev-qt/qtcore:4[${MULTILIB_USEDEP}]
		dev-qt/qtgui:4[${MULTILIB_USEDEP}] )
	X? (
		x11-libs/libXext[${MULTILIB_USEDEP}]
		xv? ( x11-libs/libXv[${MULTILIB_USEDEP}] )
	)"
RDEPEND="${CDEPEND}
	java? ( >=virtual/jre-1.4 )"
DEPEND="${CDEPEND}
	java? ( >=virtual/jdk-1.4
		test? ( dev-java/junit:4
			dev-java/hamcrest-core:1.3 ) )
	test? ( ${PYTHON_DEPS} )
	app-arch/unzip
	sys-devel/gettext
	virtual/pkgconfig"

pkg_setup() {
	if use python || use test; then
		python-single-r1_pkg_setup
	fi
	java-pkg-opt-2_pkg_setup
}

src_unpack() {
	#vcs-snapshot doesn't work on .zip
	default
	mv * ${P} || die
}

src_prepare() {
	eapply "${FILESDIR}"/${PN}-0.10-errors.patch \
		"${FILESDIR}"/${PN}-0.10-python-crash.patch \
		"${FILESDIR}"/${PN}-0.10-v4l2-uvcvideo.patch

	# fix use of deprecated qt4 function, bug 572488
	sed -e 's:numBytes:byteCount:g' \
		-i "${S}"/include/zbar/QZBarImage.h || die

	if has_version '>=media-gfx/imagemagick-7.0.1.0' ; then
		eapply "${FILESDIR}/${P}-ImageMagick-7.diff"
	fi

	use python && python_fix_shebang examples/upcrpc.py test/*.py
	java-pkg-opt-2_src_prepare

	sed -e '/AM_INIT_AUTOMAKE/s: -Werror : :' \
		-e '/^AM_CFLAGS=/s: -Werror::' \
		-i configure.ac || die
	sed "s|javadir = \$(pkgdatadir)|javadir = /usr/$(get_libdir)/zbar|" \
		-i java/Makefile.am
	eautoreconf
}

multilib_src_configure() {
	if multilib_is_native_abi && use java; then
		export JAVACFLAGS="$(java-pkg_javac-args)"
		export JAVA_CFLAGS="$(java-pkg_get-jni-cflags)"
		if use test ; then # bug 629078
			java-pkg_append_ CLASSPATH .
			java-pkg_append_ CLASSPATH $(java-pkg_getjar --build-only junit-4 junit.jar)
			java-pkg_append_ CLASSPATH $(java-pkg_getjar --build-only hamcrest-core-1.3 hamcrest-core.jar)
		fi
	fi

	append-cppflags -DNDEBUG

	# different flags for image/graphics magick (bug 552350)
	myimagemagick="--without-imagemagick"
	has_version media-gfx/imagemagick &&
		myimagemagick="$(multilib_native_use_with imagemagick)"
	mygraphicsmagick="--without-graphicsmagick"
	has_version media-gfx/graphicsmagick &&
		mygraphicsmagick="$(multilib_native_use_with imagemagick graphicsmagick)"
	ECONF_SOURCE=${S} \
	econf \
		$(multilib_native_use_with java) \
		$(use_with jpeg) \
		$(use_with gtk) \
		${myimagemagick} \
		${mygraphicsmagick} \
		$(multilib_native_use_with python) \
		$(use_with qt4 qt) \
		$(use_enable static-libs static) \
		$(use_enable threads pthread) \
		$(use_with X x) \
		$(use_with xv xv) \
		$(use_enable v4l video)

	# work-around out-of-source build issue
	mkdir gtk pygtk qt test || die
}

src_test() {
	virtx multilib-minimal_src_test
}

multilib_src_install_all() {
	dodoc HACKING NEWS README TODO
	find "${D}" -name '*.la' -delete || die
}

pkg_preinst() {
	java-pkg-opt-2_pkg_preinst
}
