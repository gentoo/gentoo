# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Cross-platform library for building Telegram clients"
HOMEPAGE="https://core.telegram.org/tdlib"
SRC_URI="https://github.com/tdlib/td/archive/v${PV}.tar.gz -> ${P}.tar.gz"
RESTRICT="mirror"

LICENSE="Boost-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="clang cli debug doc +gcc java low-ram lto test"
RESTRICT="!test? ( test )"

REQUIRED_USE="
	gcc? ( !clang )
	!gcc? ( clang )
	java? ( !lto )
"
# according to TDLib build instructions, lto excludes java

S="${WORKDIR}/td-${PV}"

BDEPEND="gcc? ( >=sys-devel/gcc-4.9.2 )
	>=dev-util/cmake-3.0.2
	dev-util/gperf
	lto? ( >=dev-util/cmake-3.9.0 )
	clang? ( >=sys-devel/clang-3.4:= )
	low-ram? ( dev-lang/php[cli] )
	doc? ( app-doc/doxygen )
	java? ( virtual/jdk:= )"

# todo: tdlib apparently uses sqlite but sqlite is not required in the build manual
# maybe we'll have to provide system-sqlite USE flag
# pg_overlay has sqlite-related stuff in its src_prepare

RDEPEND="dev-libs/openssl:0=
	sys-libs/zlib"

DOCS=( README.md )

src_prepare() {

	eapply "${FILESDIR}/${PN}"-1.7.0-fix-runpath.patch

	# from mva
	sed -r \
		-e '/install\(TARGETS/,/  INCLUDES/{s@(LIBRARY DESTINATION).*@\1 ${CMAKE_INSTALL_LIBDIR}@;s@(ARCHIVE DESTINATION).*@\1 ${CMAKE_INSTALL_LIBDIR}@;s@(RUNTIME DESTINATION).*@\1 ${CMAKE_INSTALL_BINDIR}@}' \
		-i CMakeLists.txt

	# from pg_overlay
	if use test
	then
		sed -i -e '/run_all_tests/! {/all_tests/d}' \
			test/CMakeLists.txt || die
	else
		sed -i \
			-e '/enable_testing/d' \
			-e '/add_subdirectory.*test/d' \
			CMakeLists.txt || die
	fi
	# for now, tests segfault for me on glibc and musl

	cmake_src_prepare
}

src_configure(){
	local mycmakeargs=(
		-DCMAKE_BUILD_TYPE=$(usex debug Debug Release)
		-DCMAKE_INSTALL_PREFIX=/usr
		-DTD_ENABLE_LTO=$(usex lto ON OFF)
		-DTD_ENABLE_JNI=$(usex java ON OFF)
		# According to TDLib build instructions, DOTNET=ON is only needed
		# for using tdlib from C# under Windows through C++/CLI
		-DTD_ENABLE_DOTNET=OFF
	)

	cmake_src_configure

	if use low-ram; then
		cmake --build "${BUILD_DIR}" --target prepare_cross_compiling
		php SplitSource.php || die
		# todo: we need to die on errors here but I don't know how
		# the current || die will only die on missing php
	fi

}

src_compile() {

	cmake_src_compile

	# from pg_overlay
	if use doc ; then
		doxygen Doxyfile || die "Could not build docs with doxygen"
	fi
	# completes without errors but I don't know if it's sensible
}

src_install() {

	cmake_src_install

	use cli && dobin "${BUILD_DIR}"/tg_cli
	# can't we just skip it during build?

	# from pg_overlay
	use doc && local HTML_DOCS=( docs/html/. )
	einstalldocs

}
