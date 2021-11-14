# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake desktop xdg-utils flag-o-matic

PATCHSET_VER="0"

DESCRIPTION="Versatile implementation of the Prolog programming language"
HOMEPAGE="https://www.swi-prolog.org/"
SRC_URI="https://www.swi-prolog.org/download/devel/src/swipl-${PV}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="archive berkdb debug doc +gmp java +libedit minimal odbc pcre qt5 readline ssl test +uuid X yaml"
RESTRICT="!test? ( test )"

RDEPEND="sys-libs/ncurses:=
	sys-libs/zlib
	virtual/libcrypt:=
	archive? ( app-arch/libarchive:= )
	berkdb? ( >=sys-libs/db-4:= )
	odbc? ( dev-db/unixODBC )
	pcre? ( dev-libs/libpcre )
	readline? ( sys-libs/readline:= )
	libedit? ( dev-libs/libedit )
	gmp? ( dev-libs/gmp:0= )
	ssl? ( dev-libs/openssl:0= )
	java? ( >=virtual/jdk-1.8:* )
	uuid? ( dev-libs/ossp-uuid )
	qt5? (
		dev-qt/qtwidgets:5
		dev-qt/qtgui:5
	)
	X? (
		virtual/jpeg:0
		x11-libs/libX11
		x11-libs/libXft
		x11-libs/libXinerama
		x11-libs/libXpm
		x11-libs/libXt
		x11-libs/libICE
		x11-libs/libSM )
	yaml? ( dev-libs/libyaml )"

DEPEND="${RDEPEND}
	X? ( x11-base/xorg-proto )
	java? ( test? ( =dev-java/junit-3.8* ) )"

S="${WORKDIR}/swipl-${PV}"

src_prepare() {
	if [[ -d "${WORKDIR}"/${PV} ]] ; then
		eapply "${WORKDIR}"/${PV}
	fi

	sed -e "s|\(SWIPL_INSTALL_PREFIX\)   lib/.*)|\1   $(get_libdir)/swipl)|" \
		-e "s|\(SWIPL_INSTALL_CMAKE_CONFIG_DIR\) lib/|\1   $(get_libdir)/|" \
		-i CMakeLists.txt || die

	local ncurses_lib_flags=$(pkg-config --libs ncurses)
	sed -i "/project(SWI-Prolog)/a set(CMAKE_REQUIRED_LIBRARIES \${CMAKE_REQUIRED_LIBRARIES} ${ncurses_lib_flags})" CMakeLists.txt || die
	sed -i "s:\${CURSES_LIBRARIES}:${ncurses_lib_flags}:" src/CMakeLists.txt || die

	cmake_src_prepare
}

src_configure() {
	append-flags -fno-strict-aliasing
	use debug && append-flags -DO_DEBUG

	local mycmakeargs=(
		-DSWIPL_INSTALL_PREFIX=$(get_libdir)/swipl
		-DUSE_GMP=$(usex gmp)
		-DINSTALL_DOCUMENTATION=$(use doc && usex archive)
		-DSWIPL_PACKAGES_BASIC=$(usex !minimal)
		-DSWIPL_PACKAGES_ARCHIVE=$(usex archive)
		-DSWIPL_PACKAGES_ODBC=$(usex odbc)
		-DSWIPL_PACKAGES_BDB=$(usex berkdb)
		-DSWIPL_PACKAGES_PCRE=$(usex pcre)
		-DSWIPL_PACKAGES_YAML=$(usex yaml)
		-DSWIPL_PACKAGES_SSL=$(usex ssl)
		-DSWIPL_PACKAGES_JAVA=$(usex java)
		-DSWIPL_PACKAGES_QT=$(usex qt5)
		-DSWIPL_PACKAGES_X=$(usex X)
		-DSWIPL_PACKAGES_TERM=$(if use libedit || use readline; then echo yes; else echo no; fi)
	)

	cmake_src_configure
}

src_compile() {
	XDG_CONFIG_DIRS="${HOME}" \
	XDG_DATA_DIRS="${HOME}" \
		cmake_src_compile
}

src_test() {
	USE_PUBLIC_NETWORK_TESTS=false \
	USE_ODBC_TESTS=false \
		cmake_src_test -V
}

src_install() {
	cmake_src_install

	if use qt5; then
		doicon "${S}"/snap/gui/swipl.png
		make_desktop_entry swipl-win "SWI-Prolog" swipl "Development"
	fi
}

pkg_postinst() {
	if use qt5; then
		xdg_icon_cache_update
		xdg_desktop_database_update
	fi
}

pkg_postrm() {
	if use qt5; then
		xdg_icon_cache_update
		xdg_desktop_database_update
	fi
}
