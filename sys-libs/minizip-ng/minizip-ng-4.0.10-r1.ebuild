# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Worth keeping an eye on 'develop' branch upstream for possible backports,
# as they copied this practice from sys-libs/zlib upstream.

inherit cmake-multilib multibuild

DESCRIPTION="Fork of the popular zip manipulation library found in the zlib distribution"
HOMEPAGE="https://github.com/zlib-ng/minizip-ng"
SRC_URI="https://github.com/zlib-ng/minizip-ng/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ZLIB"
SLOT="0/4"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~ppc64 ~riscv ~x86"
IUSE="compat lzma openssl test zstd"
RESTRICT="!test? ( test )"

# Automagically prefers sys-libs/zlib-ng if installed, so let's
# just depend on it as presumably it's better tested anyway.
RDEPEND="
	app-arch/bzip2[${MULTILIB_USEDEP}]
	dev-libs/libbsd[${MULTILIB_USEDEP}]
	sys-libs/zlib-ng[${MULTILIB_USEDEP}]
	virtual/libiconv
	compat? ( !sys-libs/zlib[minizip] )
	lzma? ( app-arch/xz-utils )
	openssl? ( dev-libs/openssl:=[${MULTILIB_USEDEP}] )
	zstd? ( app-arch/zstd:=[${MULTILIB_USEDEP}] )
"
DEPEND="
	${RDEPEND}
	test? ( dev-cpp/gtest )
"

PATCHES=(
	"${FILESDIR}"/${PN}-4.0.4-libbsd-overlay.patch
)

run_both() {
	local MULTIBUILD_VARIANTS=( base )
	use compat && MULTIBUILD_VARIANTS+=( compat )

	multibuild_foreach_variant "${@}"
}

my_src_configure() {
	local compat=OFF
	[[ ${MULTIBUILD_VARIANT} == compat ]] && compat=ON
	local mycmakeargs=(
		"${mycmakeargs[@]}"
		-DMZ_COMPAT="${compat}"
	)

	cmake_src_configure
}

multilib_src_configure() {
	local mycmakeargs=(
		# Controls installing "minizip" and "minigzip" tools.  Install
		# them unconditionally to avoid divergence with USE=test.
		-DMZ_BUILD_TESTS=ON
		-DMZ_BUILD_UNIT_TESTS=$(usex test)

		-DMZ_FETCH_LIBS=OFF
		-DMZ_FORCE_FETCH_LIBS=OFF

		# Compression library options
		-DMZ_ZLIB=ON
		-DMZ_BZIP2=ON
		-DMZ_LZMA=$(usex lzma)
		-DMZ_ZSTD=$(usex zstd)
		-DMZ_LIBCOMP=OFF

		# Encryption support options
		-DMZ_PKCRYPT=ON
		-DMZ_WZAES=ON
		-DMZ_OPENSSL=$(usex openssl)
		-DMZ_LIBBSD=ON

		# Character conversion options
		-DMZ_ICONV=ON
	)

	run_both my_src_configure
}

multilib_src_compile() { run_both cmake_src_compile; }

multilib_src_test() {
	# TODO: A bunch of tests end up looping and writing over each other's files
	# It gets better with a patch applied (see https://github.com/zlib-ng/minizip-ng/issues/623#issuecomment-1264518994)
	# but still hangs.
	local CTEST_JOBS=1
	run_both cmake_src_test
}

multilib_src_install() { run_both cmake_src_install; }

pkg_postinst() {
	if use compat ; then
		ewarn "minizip-ng is experimental and replacing the system zlib[minizip] is dangerous"
		ewarn "Please be careful!"
	fi
}
