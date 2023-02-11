# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake desktop flag-o-matic java-pkg-opt-2 toolchain-funcs xdg

PATCHSET_VER="0"

MY_P="swipl-${PV}"
DESCRIPTION="Versatile implementation of the Prolog programming language"
HOMEPAGE="https://www.swi-prolog.org/"
SRC_URI="https://www.swi-prolog.org/download/devel/src/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="X archive berkdb +cli debug doc +gmp gui +ipc java minimal odbc pcre pgo qt6 ssl test yaml"
RESTRICT="!test? ( test )"

# See cmake/PackageSelection.cmake and cmake/DocDepends.cmake
REQUIRED_USE="
	doc? ( archive )
	minimal? ( !archive !doc !ipc !ssl !test )
"

COMMON_DEPEND="
	sys-libs/ncurses:=
	sys-libs/zlib:=
	virtual/libcrypt:=
	X? (
		media-libs/freetype:2
		media-libs/fontconfig:1.0
		media-libs/libjpeg-turbo:=
		x11-libs/libICE
		x11-libs/libSM
		x11-libs/libX11
		x11-libs/libXft
		x11-libs/libXinerama
		x11-libs/libXpm
		x11-libs/libXt
	)
	archive? ( app-arch/libarchive:= )
	berkdb? ( >=sys-libs/db-4:= )
	cli? (
		dev-libs/libedit
		sys-libs/readline:=
	)
	gmp? ( dev-libs/gmp:0= )
	gui? (
		!qt6? (
			dev-qt/qtgui:5
			dev-qt/qtwidgets:5
		)
		qt6? ( dev-qt/qtbase:6[gui,widgets] )
	)
	!minimal? ( dev-libs/ossp-uuid )
	odbc? ( dev-db/unixODBC )
	pcre? ( dev-libs/libpcre )
	ssl? ( dev-libs/openssl:0= )
	yaml? ( dev-libs/libyaml )
"
RDEPEND="${COMMON_DEPEND}
	java? ( >=virtual/jre-1.8:* )
"
DEPEND="${COMMON_DEPEND}
	X? ( x11-base/xorg-proto )
	java? (
		>=virtual/jdk-1.8:*
		test? ( dev-java/junit:4 )
	)
"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	# Upstream in >= 9.1.3
	"${FILESDIR}"/${P}-configure-clang16.patch
)

pkg_setup() {
	java-pkg-opt-2_pkg_setup
}

src_prepare() {
	if [[ -d "${WORKDIR}"/${PV} ]] ; then
		eapply "${WORKDIR}"/${PV}
	fi

	sed \
		-e "s|\(SWIPL_INSTALL_PREFIX\)   lib/.*)|\1   $(get_libdir)/swipl)|" \
		-e "s|\(SWIPL_INSTALL_CMAKE_CONFIG_DIR\) lib/|\1   $(get_libdir)/|" \
		-i CMakeLists.txt || die

	sed "s/ -Werror//g" \
		-i cmake/GCCBuiltins.cmake \
		-i cmake/Config.cmake \
		-i packages/ssl/CMakeLists.txt || die

	local ncurses_lib_flags=$($(tc-getPKG_CONFIG) --libs ncurses)
	sed -i "/project(SWI-Prolog)/a set(CMAKE_REQUIRED_LIBRARIES \${CMAKE_REQUIRED_LIBRARIES} ${ncurses_lib_flags})" CMakeLists.txt || die
	sed -i "s:\${CURSES_LIBRARIES}:${ncurses_lib_flags}:" src/CMakeLists.txt || die

	java-pkg-opt-2_src_prepare
	cmake_src_prepare
}

src_configure() {
	append-flags -fno-strict-aliasing
	use debug && append-flags -DO_DEBUG

	if use pgo; then
		CMAKE_BUILD_TYPE="PGO"
		append-flags -Wno-error=coverage-mismatch
	fi

	local mycmakeargs=(
		-DBUILD_TESTING=$(usex test)
		-DINSTALL_DOCUMENTATION=$(usex doc)
		-DSWIPL_INSTALL_PREFIX=$(get_libdir)/swipl
		-DSWIPL_PACKAGES_ARCHIVE=$(usex archive)
		-DSWIPL_PACKAGES_BASIC=$(usex !minimal)
		-DSWIPL_PACKAGES_BDB=$(usex berkdb)
		-DSWIPL_PACKAGES_JAVA=$(usex java)
		-DSWIPL_PACKAGES_ODBC=$(usex odbc)
		-DSWIPL_PACKAGES_PCRE=$(usex pcre)
		-DSWIPL_PACKAGES_SSL=$(usex ssl)
		-DSWIPL_PACKAGES_TERM=$(usex cli)
		-DSWIPL_PACKAGES_TIPC=$(usex ipc)
		-DSWIPL_PACKAGES_X=$(usex X)
		-DSWIPL_PACKAGES_YAML=$(usex yaml)
		-DUSE_GMP=$(usex gmp)
		-DUSE_TCMALLOC=OFF
	)

	if use gui; then
		mycmakeargs+=(
			-DSWIPL_PACKAGES_QT=yes
			$(cmake_use_find_package qt6 Qt6)
		)
	else
		mycmakeargs+=( -DSWIPL_PACKAGES_QT=no )
	fi

	if use test && use java; then
		mycmakeargs+=( -DJUNIT_JAR="${ESYSROOT}"/usr/share/junit-4/lib/junit.jar )
	fi

	export XDG_CONFIG_DIRS="${HOME}"
	export XDG_DATA_DIRS="${HOME}"

	cmake_src_configure
}

src_install() {
	cmake_src_install

	if use gui; then
		doicon "${S}"/snap/gui/swipl.png
		make_desktop_entry swipl-win "SWI-Prolog" swipl "Development"
	fi
}

pkg_preinst() {
	java-pkg-opt-2_pkg_preinst
	use gui && xdg_pkg_preinst
}

pkg_postinst() {
	use gui && xdg_pkg_postinst
}

pkg_postrm() {
	use gui && xdg_pkg_postrm
}
