# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Fork of the popular zip manipulation library found in the zlib distribution"
HOMEPAGE="https://github.com/zlib-ng/minizip-ng"
SRC_URI="https://github.com/zlib-ng/minizip-ng/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="compat openssl test zstd"
RESTRICT="!test? ( test )"

# Automagically prefers sys-libs/zlib-ng if installed, so let's
# just depend on it as presumably it's better tested anyway.
RDEPEND="
	app-arch/bzip2
	app-arch/xz-utils
	sys-libs/zlib-ng
	virtual/libiconv
	compat? ( !sys-libs/zlib[minizip] )
	openssl? ( dev-libs/openssl:= )
	zstd? ( app-arch/zstd:= )
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-3.0.6-Switch-getrandom-and-arc4random_buf-usage-order.patch
	"${FILESDIR}"/${P}-test-temporary.patch
)

src_configure() {
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
		# TODO: Re-enable, ideally unconditionally, for arc4random
		# Revisit when https://github.com/zlib-ng/minizip-ng/pull/648 fixed
		-DMZ_LIBBSD=ON
		-DMZ_SIGNING=ON

		# Character conversion options
		-DMZ_ICONV=ON
	)

	cmake_src_configure
}

src_test() {
	local myctestargs=(
		# TODO: investigate
		-E "(raw-unzip-pkcrypt|raw-append-unzip-pkcrypt|raw-erase-unzip-pkcrypt|deflate-unzip-pkcrypt|deflate-append-unzip-pkcrypt|deflate-erase-unzip-pkcrypt|bzip2-unzip-pkcrypt|bzip2-append-unzip-pkcrypt|bzip2-erase-unzip-pkcrypt|lzma-unzip-pkcrypt|lzma-append-unzip-pkcrypt|lzma-erase-unzip-pkcrypt|xz-unzip-pkcrypt|xz-append-unzip-pkcrypt|xz-erase-unzip-pkcrypt|zstd-unzip-pkcrypt|zstd-append-unzip-pkcrypt|zstd-erase-unzip-pkcrypt)"
	)

	# TODO: A bunch of tests end up looping and writing over each other's files
	# It gets better with a patch applied (see https://github.com/zlib-ng/minizip-ng/issues/623#issuecomment-1264518994)
	# but still hangs.
	cmake_src_test -j1
}

src_install() {
	cmake_src_install

	if use compat ; then
		ewarn "minizip-ng is experimental and replacing the system zlib[minizip] is dangerous"
		ewarn "Please be careful!"
	fi
}
