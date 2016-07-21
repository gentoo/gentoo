# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit toolchain-funcs pax-utils multiprocessing

DESCRIPTION="A headless WebKit scriptable with a JavaScript API"
HOMEPAGE="http://phantomjs.org/"
SRC_URI="https://bitbucket.org/ariya/phantomjs/downloads/${P}-source.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="examples"

RDEPEND="dev-libs/icu:=
	dev-libs/openssl
	media-libs/fontconfig
	media-libs/freetype
	media-libs/gstreamer:0.10
	media-libs/gst-plugins-base:0.10"
DEPEND="${RDEPEND}
	app-arch/unzip
	virtual/pkgconfig"

src_prepare() {
	sed -i \
		-e '/^# CONFIG += text_breaking_with_icu/s:#::' \
		src/qt/src/3rdparty/webkit/Source/JavaScriptCore/JavaScriptCore.pri \
		|| die

	# Respect CC, CXX, {C,CXX,LD}FLAGS in .qmake.cache
	sed -i \
		-e "/^SYSTEM_VARIABLES=/i \
		CC='$(tc-getCC)'\n\
		CXX='$(tc-getCXX)'\n\
		CFLAGS='${CFLAGS}'\n\
		CXXFLAGS='${CXXFLAGS}'\n\
		LDFLAGS='${LDFLAGS}'\n\
		QMakeVar set QMAKE_CFLAGS_RELEASE\n\
		QMakeVar set QMAKE_CFLAGS_DEBUG\n\
		QMakeVar set QMAKE_CXXFLAGS_RELEASE\n\
		QMakeVar set QMAKE_CXXFLAGS_DEBUG\n\
		QMakeVar set QMAKE_LFLAGS_RELEASE\n\
		QMakeVar set QMAKE_LFLAGS_DEBUG\n"\
		src/qt/configure \
		|| die

	# Respect CC, CXX, LINK and *FLAGS in config.tests
	find src/qt/config.tests/unix -name '*.test' -type f -exec \
		sed -i -e "/bin\/qmake/ s: \"\$SRCDIR/: \
			'QMAKE_CC=$(tc-getCC)'    'QMAKE_CXX=$(tc-getCXX)'      'QMAKE_LINK=$(tc-getCXX)' \
			'QMAKE_CFLAGS+=${CFLAGS}' 'QMAKE_CXXFLAGS+=${CXXFLAGS}' 'QMAKE_LFLAGS+=${LDFLAGS}'&:" \
		{} + || die
}

src_compile() {
	./build.sh \
		--confirm \
		--jobs $(makeopts_jobs) \
		--qt-config "$($(tc-getPKG_CONFIG) --cflags-only-I freetype2)" \
		|| die
}

src_test() {
	./bin/phantomjs test/run-tests.js || die
}

src_install() {
	pax-mark m bin/phantomjs || die
	dobin bin/phantomjs
	dodoc ChangeLog README.md
	if use examples ; then
		docinto examples
		dodoc examples/*
	fi
}
