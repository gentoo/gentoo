# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit qt4-build-multilib

DESCRIPTION="Cross-platform application development framework"

if [[ ${QT4_BUILD_TYPE} == release ]]; then
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd ~x86-fbsd"
fi

IUSE="+glib iconv icu qt3support ssl"

DEPEND="
	>=sys-libs/zlib-1.2.8-r1[${MULTILIB_USEDEP}]
	glib? ( dev-libs/glib:2[${MULTILIB_USEDEP}] )
	iconv? ( >=virtual/libiconv-0-r2[${MULTILIB_USEDEP}] )
	icu? ( dev-libs/icu:=[${MULTILIB_USEDEP}] )
	ssl? ( >=dev-libs/openssl-1.0.1h-r2:0[${MULTILIB_USEDEP}] )
"
RDEPEND="${DEPEND}"
PDEPEND="
	~dev-qt/qttranslations-${PV}
	qt3support? ( ~dev-qt/qtgui-${PV}[aqua=,debug=,glib=,qt3support,${MULTILIB_USEDEP}] )
"

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/qt4/Qt/qconfig.h
	/usr/include/qt4/QtCore/qconfig.h
)

PATCHES=(
	"${FILESDIR}/${PN}-4.8.5-moc-boost-lexical-cast.patch"
	"${FILESDIR}/${PN}-4.8.5-honor-ExcludeSocketNotifiers-in-glib-event-loop.patch" # bug 514968
	"${FILESDIR}/${PN}-4.8.5-qeventdispatcher-recursive.patch" # bug 514968
)

QT4_TARGET_DIRECTORIES="
	src/tools/bootstrap
	src/tools/moc
	src/tools/rcc
	src/tools/uic
	src/corelib
	src/network
	src/xml
	src/plugins/codecs/cn
	src/plugins/codecs/jp
	src/plugins/codecs/kr
	src/plugins/codecs/tw
	tools/linguist/lconvert
	tools/linguist/lrelease
	tools/linguist/lupdate"

QCONFIG_DEFINE="QT_ZLIB"

src_prepare() {
	qt4-build-multilib_src_prepare

	# bug 172219
	sed -i -e "s:CXXFLAGS.*=:CXXFLAGS=${CXXFLAGS} :" \
		-e "s:LFLAGS.*=:LFLAGS=${LDFLAGS} :" \
		qmake/Makefile.unix || die "sed qmake/Makefile.unix failed"

	# bug 427782
	sed -i -e '/^CPPFLAGS\s*=/ s/-g //' \
		qmake/Makefile.unix || die "sed CPPFLAGS in qmake/Makefile.unix failed"
	sed -i -e 's/setBootstrapVariable QMAKE_CFLAGS_RELEASE/QMakeVar set QMAKE_CFLAGS_RELEASE/' \
		-e 's/setBootstrapVariable QMAKE_CXXFLAGS_RELEASE/QMakeVar set QMAKE_CXXFLAGS_RELEASE/' \
		configure || die "sed configure setBootstrapVariable failed"
}

multilib_src_configure() {
	local myconf=(
		-no-accessibility -no-xmlpatterns -no-multimedia -no-audio-backend -no-phonon
		-no-phonon-backend -no-svg -no-webkit -no-script -no-scripttools -no-declarative
		-system-zlib -no-gif -no-libtiff -no-libpng -no-libmng -no-libjpeg
		-no-cups -no-dbus -no-gtkstyle -no-nas-sound -no-opengl -no-openvg
		-no-sm -no-xshape -no-xvideo -no-xsync -no-xinerama -no-xcursor -no-xfixes
		-no-xrandr -no-xrender -no-mitshm -no-fontconfig -no-freetype -no-xinput -no-xkb
		$(qt_use glib)
		$(qt_use iconv)
		$(qt_use icu)
		$(use ssl && echo -openssl-linked || echo -no-openssl)
		$(qt_use qt3support)
	)
	qt4_multilib_src_configure
}
