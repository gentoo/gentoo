# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

REAL_PN="swipl"
REAL_P="${REAL_PN}-${PV}"

inherit cmake desktop flag-o-matic java-pkg-opt-2 toolchain-funcs xdg

DESCRIPTION="Versatile implementation of the Prolog programming language"
HOMEPAGE="https://www.swi-prolog.org/
	https://github.com/SWI-Prolog/swipl-devel/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/SWI-Prolog/swipl-devel"
else
	SRC_URI="https://www.swi-prolog.org/download/stable/src/${REAL_P}.tar.gz"
	S="${WORKDIR}/${REAL_P}"

	KEYWORDS="amd64 ~ppc ~x86"
fi

LICENSE="BSD-2"
SLOT="0"
IUSE="archive berkdb +cli debug doc +gmp gui +ipc java minimal odbc pcre pgo ssl test yaml"
RESTRICT="!test? ( test )"

# See "cmake/PackageSelection.cmake" and "cmake/DocDepends.cmake" in pkg source.
REQUIRED_USE="
	doc? ( archive )
	minimal? ( !archive !doc !ipc !ssl !test )
"

COMMON_DEPEND="
	sys-libs/ncurses:=
	virtual/zlib:=
	virtual/libcrypt:=
	!minimal? (
		dev-libs/ossp-uuid
	)
	archive? (
		app-arch/libarchive:=
	)
	berkdb? (
		>=sys-libs/db-4:=
	)
	cli? (
		dev-libs/libedit
	)
	gmp? (
		dev-libs/gmp:0=
	)
	gui? (
		 dev-libs/glib:2
		 media-libs/sdl3-image
		 x11-libs/pango
	)
	odbc? (
		dev-db/unixODBC
	)
	pcre? (
		dev-libs/libpcre
	)
	ssl? (
		dev-libs/openssl:0=
	)
	yaml? (
		dev-libs/libyaml
	)
"
RDEPEND="
	${COMMON_DEPEND}
	java? (
		>=virtual/jre-1.8:*
	)
"
DEPEND="
	${COMMON_DEPEND}
	java? (
		>=virtual/jdk-1.8:*
	)
"
BDEPEND="
	virtual/pkgconfig
	test? (
		java? (
			dev-java/junit:4
		)
	)
"

pkg_setup() {
	java-pkg-opt-2_pkg_setup
}

src_prepare() {
	sed -e "s|\(SWIPL_INSTALL_PREFIX\)   lib/.*)|\1   $(get_libdir)/swipl)|" \
		-e "s|\(SWIPL_INSTALL_CMAKE_CONFIG_DIR\) lib/|\1   $(get_libdir)/|" \
		-i CMakeLists.txt \
		|| die

	sed -e "s/ -Werror//g" \
		-i cmake/GCCBuiltins.cmake \
		-i cmake/Config.cmake \
		-i packages/ssl/CMakeLists.txt \
		|| die

	local ncurses_lib_flags=$($(tc-getPKG_CONFIG) --libs ncurses)
	sed -e "/project(SWI-Prolog)/a set(CMAKE_REQUIRED_LIBRARIES \${CMAKE_REQUIRED_LIBRARIES} ${ncurses_lib_flags})" \
		-i  CMakeLists.txt \
		|| die
	sed -e "s:\${CURSES_LIBRARIES}:${ncurses_lib_flags}:" \
		-i src/CMakeLists.txt \
		|| die

	java-pkg-opt-2_src_prepare
	cmake_src_prepare
}

src_configure() {
	export XDG_CONFIG_DIRS="${HOME}"
	export XDG_DATA_DIRS="${HOME}"

	# Lots of UB, see https://gcc.gnu.org/PR113521
	filter-lto
	append-flags -fno-strict-aliasing

	if use debug ; then
		append-flags -DO_DEBUG
	fi

	if use pgo ; then
		CMAKE_BUILD_TYPE="PGO"
		append-flags -Wno-error=coverage-mismatch
	fi

	local -a mycmakeargs=(
		-DBUILD_TESTING=$(usex test)

		-DSWIPL_INSTALL_PREFIX="$(get_libdir)/swipl"
		-DINSTALL_DOCUMENTATION=$(usex doc)

		-DUSE_GMP=$(usex gmp)
		-DUSE_TCMALLOC="OFF"
		-DSWIPL_PACKAGES_BASIC=$(usex !minimal)

		-DSWIPL_PACKAGES_ARCHIVE=$(usex archive)
		-DSWIPL_PACKAGES_BDB=$(usex berkdb)
		-DSWIPL_PACKAGES_GUI=$(usex gui)
		-DSWIPL_PACKAGES_JAVA=$(usex java)
		-DSWIPL_PACKAGES_ODBC=$(usex odbc)
		-DSWIPL_PACKAGES_PCRE=$(usex pcre)
		-DSWIPL_PACKAGES_SSL=$(usex ssl)
		-DSWIPL_PACKAGES_TERM=$(usex cli)
		-DSWIPL_PACKAGES_TIPC=$(usex ipc)
		-DSWIPL_PACKAGES_YAML=$(usex yaml)
	)

	if use cli ; then
		mycmakeargs+=(
			-DSYSTEM_LIBEDIT="ON"
		)
	fi

	if use test && use java ; then
		mycmakeargs+=(
			-DJUNIT_JAR="${ESYSROOT}/usr/share/junit-4/lib/junit.jar"
		)
	fi

	cmake_src_configure
}

src_install() {
	cmake_src_install

	if use gui ; then
		doicon "${S}/desktop/swipl-cli.png"
		make_desktop_entry "swipl-win" "SWI-Prolog" "swipl" "Development"
	fi
}

pkg_preinst() {
	java-pkg-opt-2_pkg_preinst

	if use gui ; then
		xdg_pkg_preinst
	fi
}

pkg_postinst() {
	if use gui ; then
		xdg_pkg_postinst
	fi
}

pkg_postrm() {
	if use gui ; then
		xdg_pkg_postrm
	fi
}
