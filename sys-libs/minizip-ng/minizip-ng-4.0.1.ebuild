# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Worth keeping an eye on 'develop' branch upstream for possible backports,
# as they copied this practice from sys-libs/zlib upstream.

inherit cmake-multilib

DESCRIPTION="Fork of the popular zip manipulation library found in the zlib distribution"
HOMEPAGE="https://github.com/zlib-ng/minizip-ng"
SRC_URI="https://github.com/zlib-ng/minizip-ng/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ZLIB"
SLOT="0/4"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"
IUSE="compat openssl test zstd"
RESTRICT="!test? ( test )"

# Automagically prefers sys-libs/zlib-ng if installed, so let's
# just depend on it as presumably it's better tested anyway.
RDEPEND="
	app-arch/bzip2[${MULTILIB_USEDEP}]
	app-arch/xz-utils
	sys-libs/zlib-ng[${MULTILIB_USEDEP}]
	virtual/libiconv
	compat? ( !sys-libs/zlib[minizip] )
	openssl? ( dev-libs/openssl:=[${MULTILIB_USEDEP}] )
	zstd? ( app-arch/zstd:=[${MULTILIB_USEDEP}] )
"
DEPEND="
	${RDEPEND}
	test? ( dev-cpp/gtest )
"

multilib_src_configure() {
	local mycmakeargs=(
		-DMZ_COMPAT=$(usex compat)

		-DMZ_BUILD_TESTS=$(usex test)
		-DMZ_BUILD_UNIT_TESTS=$(usex test)

		-DMZ_FETCH_LIBS=OFF
		-DMZ_FORCE_FETCH_LIBS=OFF

		# Compression library options
		-DMZ_ZLIB=ON
		-DMZ_BZIP2=ON
		-DMZ_LZMA=ON
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

	cmake_src_configure
}

multilib_src_test() {
	local myctestargs=(
		# TODO: investigate
		-E "(raw-unzip-pkcrypt|raw-append-unzip-pkcrypt|raw-erase-unzip-pkcrypt|deflate-unzip-pkcrypt|deflate-append-unzip-pkcrypt|deflate-erase-unzip-pkcrypt|bzip2-unzip-pkcrypt|bzip2-append-unzip-pkcrypt|bzip2-erase-unzip-pkcrypt|lzma-unzip-pkcrypt|lzma-append-unzip-pkcrypt|lzma-erase-unzip-pkcrypt|xz-unzip-pkcrypt|xz-append-unzip-pkcrypt|xz-erase-unzip-pkcrypt|zstd-unzip-pkcrypt|zstd-append-unzip-pkcrypt|zstd-erase-unzip-pkcrypt)"
	)

	# TODO: A bunch of tests end up looping and writing over each other's files
	# It gets better with a patch applied (see https://github.com/zlib-ng/minizip-ng/issues/623#issuecomment-1264518994)
	# but still hangs.
	cmake_src_test -j1
}

multilib_src_install_all() {
	if ! use compat && use test ; then
		# Test binaries, bug #874591
		rm "${ED}"/usr/bin/minigzip || die
		rm "${ED}"/usr/bin/minizip-ng || die
	fi
}

pkg_postinst() {
	if use compat ; then
		ewarn "minizip-ng is experimental and replacing the system zlib[minizip] is dangerous"
		ewarn "Please be careful!"
	fi
}
