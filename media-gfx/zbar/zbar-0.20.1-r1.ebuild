# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit autotools flag-o-matic java-pkg-opt-2 multilib-minimal python-single-r1 virtualx

DESCRIPTION="Library and tools for reading barcodes from images or video"
HOMEPAGE="https://github.com/mchehab/zbar"
SRC_URI="https://linuxtv.org/downloads/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm x86"

IUSE="graphicsmagick gtk imagemagick java jpeg python qt5 static-libs test +threads v4l X xv"
RESTRICT="!test? ( test )"
REQUIRED_USE="
	python? ( ${PYTHON_REQUIRED_USE} )
	test? ( X ${PYTHON_REQUIRED_USE} )
"

COMMON_DEPEND="
	gtk? (
		dev-libs/glib:2[${MULTILIB_USEDEP}]
		x11-libs/gtk+:2[${MULTILIB_USEDEP}]
	)
	imagemagick? (
		!graphicsmagick? ( media-gfx/imagemagick:= )
		graphicsmagick? ( media-gfx/graphicsmagick:= )
	)
	jpeg? ( virtual/jpeg:0[${MULTILIB_USEDEP}] )
	python? (
		${PYTHON_DEPS}
		gtk? ( >=dev-python/pygtk-2[${PYTHON_USEDEP}] )
	)
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
		dev-qt/qtx11extras:5
	)
	v4l? ( media-libs/libv4l:0= )
	X? (
		x11-libs/libX11[${MULTILIB_USEDEP}]
		x11-libs/libXext[${MULTILIB_USEDEP}]
		xv? ( x11-libs/libXv[${MULTILIB_USEDEP}] )
	)
"
RDEPEND="${COMMON_DEPEND}
	java? ( >=virtual/jre-1.8 )
"
DEPEND="${COMMON_DEPEND}
	sys-devel/gettext
	virtual/pkgconfig
	gtk? ( dev-util/glib-utils )
	java? (
		>=virtual/jdk-1.8
		test? (
			dev-java/junit:4
			dev-java/hamcrest-core:1.3
		)
	)
	test? ( ${PYTHON_DEPS} )
"

PATCHES=( "${FILESDIR}"/${PN}-0.10-errors.patch )

pkg_setup() {
	if use python || use test; then
		python-single-r1_pkg_setup
	fi
	java-pkg-opt-2_pkg_setup
}

src_prepare() {
	default

	if has_version '>=media-gfx/imagemagick-7.0.1.0' ; then
		eapply "${FILESDIR}/${PN}-0.10_p20121015-ImageMagick-7.patch"
	fi

	use python && python_fix_shebang examples/upcrpc.py test/*.py
	java-pkg-opt-2_src_prepare

	sed -e '/AM_INIT_AUTOMAKE/s: -Werror : :' \
		-e '/^AM_CFLAGS=/s: -Werror::' \
		-i configure.ac || die
	sed "s|javadir = \$(pkgdatadir)|javadir = /usr/$(get_libdir)/zbar|" \
		-i java/Makefile.am || die
	eautoreconf
}

multilib_src_configure() {
	append-cppflags -DNDEBUG

	local myeconfargs=(
		$(use_with gtk)
		$(multilib_native_use_with graphicsmagick graphicsmagick)
		$(multilib_native_use_with imagemagick)
		$(multilib_native_use_with java)
		$(use_with jpeg)
		$(multilib_native_use_with python python2)
		$(use_enable static-libs static)
		$(use_enable threads pthread)
		$(use_enable v4l video)
		$(use_with X x)
		$(use_with X xshm)
		$(use_with xv xv)
	)

	if multilib_is_native_abi; then
		if use java; then
			export JAVACFLAGS="$(java-pkg_javac-args)"
			export JAVA_CFLAGS="$(java-pkg_get-jni-cflags)"
			if use test ; then # bug 629078
				java-pkg_append_ CLASSPATH .
				java-pkg_append_ CLASSPATH $(java-pkg_getjar --build-only junit-4 junit.jar)
				java-pkg_append_ CLASSPATH $(java-pkg_getjar --build-only hamcrest-core-1.3 hamcrest-core.jar)
			fi
		fi
		if use qt5; then
			myeconfargs+=(
				$(use_with qt5 qt)
				$(use_with qt5)
			)
		else
			myeconfargs+=( --without-qt )
		fi
	else
			myeconfargs+=( --without-qt )
	fi

	ECONF_SOURCE=${S} \
		econf "${myeconfargs[@]}"

	# work around out-of-source build issues for multilib systems
	# https://bugs.gentoo.org/672184
	mkdir gtk pygtk qt test zbarcam || die
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
	java-pkg-opt-2_pkg_preinst
}
