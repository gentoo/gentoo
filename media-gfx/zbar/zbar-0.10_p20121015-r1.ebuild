# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit autotools eutils flag-o-matic java-pkg-opt-2 multilib python-single-r1

DESCRIPTION="Library and tools for reading barcodes from images or video"
HOMEPAGE="http://zbar.sourceforge.net/"
SRC_URI="https://dev.gentoo.org/~xmw/zbar-0.10_p20121015.zip"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="gtk imagemagick java jpeg python qt4 static-libs +threads v4l X xv"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

CDEPEND="gtk? ( dev-libs/glib:2 x11-libs/gtk+:2 )
	imagemagick? ( virtual/imagemagick-tools )
	jpeg? ( virtual/jpeg:0 )
	python? (
		${PYTHON_DEPS}
		gtk? ( >=dev-python/pygtk-2[${PYTHON_USEDEP}] )
	)
	qt4? ( dev-qt/qtcore:4 dev-qt/qtgui:4 )
	X? (
		x11-libs/libXext
		xv? ( x11-libs/libXv )
	)"
REPEND="${CDEPEND}
	java? ( >=virtual/jre-1.4 )"
DEPEND="${CDEPEND}
	java? ( >=virtual/jdk-1.4 )
	sys-devel/gettext
	virtual/pkgconfig"

pkg_setup() {
	use python && python-single-r1_pkg_setup
	java-pkg-opt-2_pkg_setup
}

src_unpack() {
	#vcs-snapshot doesn't work on .zip
	default
	mv * ${P} || die
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.10-errors.patch \
		"${FILESDIR}"/${PN}-0.10-python-crash.patch \
		"${FILESDIR}"/${PN}-0.10-v4l2-uvcvideo.patch

	use python && python_fix_shebang examples/upcrpc.py test/*.py
	java-pkg-opt-2_src_prepare

	sed -e '/AM_INIT_AUTOMAKE/s: -Werror : :' \
		-e '/^AM_CFLAGS=/s: -Werror::' \
		-i configure.ac || die
	sed "s|javadir = \$(pkgdatadir)|javadir = /usr/$(get_libdir)/zbar|" \
		-i java/Makefile.am
	eautoreconf
}

src_configure() {
	if use java; then
		export JAVACFLAGS="$(java-pkg_javac-args)"
		export JAVA_CFLAGS="$(java-pkg_get-jni-cflags)"
	fi

	append-cppflags -DNDEBUG
	econf \
		$(use_with java) \
		$(use_with jpeg) \
		$(use_with gtk) \
		$(use_with imagemagick) \
		$(use_with python) \
		$(use_with qt4 qt) \
		$(use_enable static-libs static) \
		$(use_enable threads pthread) \
		$(use_with X x) \
		$(use_with xv xv) \
		$(use_enable v4l video)
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc HACKING NEWS README TODO
	rm -r "${ED}"/usr/share/doc/${PN}
	prune_libtool_files --all
}

pkg_preinst() {
	java-pkg-opt-2_pkg_preinst
}
