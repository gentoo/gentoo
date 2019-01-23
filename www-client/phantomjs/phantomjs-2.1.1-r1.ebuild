# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_{4,5,6}} pypy{,3} )
QTB_PV="5.5.1"
QTB_P="qtbase-opensource-src-${QTB_PV}"
QTW_PV="5.7.1"
QTW_P="qtwebkit-opensource-src-${QTW_PV}"

DESCRIPTION="A headless WebKit scriptable with a JavaScript API"
HOMEPAGE="http://phantomjs.org/"
SRC_URI="https://github.com/ariya/phantomjs/archive/${PV}.tar.gz -> ${P}.tar.gz
	 https://download.qt.io/archive/qt/${QTB_PV%.*}/${QTB_PV}/submodules/${QTB_P}.tar.xz
	 https://download.qt.io/community_releases/${QTW_PV%.*}/${QTW_PV}/${QTW_P}.tar.xz
	 mirror://gentoo/gentoo-${PN}-patchset-0.02.tar.bz2"

inherit eutils toolchain-funcs pax-utils multiprocessing

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples fontconfig libressl truetype"
RESTRICT="mirror"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

EPATCH_SUFFIX="patch"
PATCHES=( "${WORKDIR}/${PN}-patchset" )

RDEPEND="dev-libs/icu:=
	fontconfig? ( media-libs/fontconfig )
	!libressl? ( dev-libs/openssl:0 )
	libressl? ( dev-libs/libressl )
	truetype? ( media-libs/freetype )
	dev-db/sqlite:3"
DEPEND="${RDEPEND}
	net-misc/openssh[-bindist]
	app-arch/unzip
	dev-lang/ruby
	virtual/pkgconfig"

src_prepare() {
	ebegin "Moving third-party libraries into position for build"
	mv -T "${WORKDIR}/${QTB_P}" "${S}/src/qt/qtbase/" || die "QT base ${QTB_PV} failed"
	mv -T "${WORKDIR}/${QTW_P}" "${S}/src/qt/qtwebkit/" || die "QT webkit ${QTW_PV} failed"
	eend "$?"

	ebegin "Instilling C/CXX/LDFLAGS respect in main source"
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
		src/qt/qtbase/configure \
		|| die
	eend $?

	ebegin "Instilling C/CXX/LDFLAGS respect in test suite"
	# Respect CC, CXX, LINK and *FLAGS in config.tests
	find src/qt/qtbase/config.tests/unix -name '*.test' -type f -exec \
		sed -i -e "/bin\/qmake/ s: \"\$SRCDIR/: \
			'QMAKE_CC=$(tc-getCC)'    'QMAKE_CXX=$(tc-getCXX)'      'QMAKE_LINK=$(tc-getCXX)' \
			'QMAKE_CFLAGS+=${CFLAGS}' 'QMAKE_CXXFLAGS+=${CXXFLAGS}' 'QMAKE_LFLAGS+=${LDFLAGS}'&:" \
		{} + || die
	eend $?

	default
}

src_compile() {
	./build.py \
		--confirm \
		--jobs $(makeopts_jobs) \
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
