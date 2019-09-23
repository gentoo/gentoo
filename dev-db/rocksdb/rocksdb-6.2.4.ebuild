# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

DESCRIPTION="Embeddable, persistent key-value store for fast storage"
HOMEPAGE="http://rocksdb.org/"
SRC_URI="https://github.com/facebook/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="|| ( GPL-2 Apache-2.0 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# NB. When compiling the JNI Java bindings it fetches a bunch of jar files, I'm
# not sure how to fix this without doing significant changes to the build
# systemd, which I don't want to do. Therefore, not to break network-sandbox, I
# removed it.
IUSE="bzip2 +gflags +jemalloc lz4 snappy test tools zlib zstd"
# NB. Tests are restricted because RocksDB makes it impossible to compile tests
# unless the whole source is configured and compiled for debug mode, which is
# obviously not what we want in the final binaries.
RESTRICT="test"

BDEPEND="virtual/pkgconfig"
DEPEND="
	bzip2? ( app-arch/bzip2:= )
	gflags? ( dev-cpp/gflags:= )
	jemalloc? ( dev-libs/jemalloc:= )
	lz4? ( app-arch/lz4:= )
	snappy? ( app-arch/snappy:= )
	zlib? ( sys-libs/zlib:= )
	zstd? ( app-arch/zstd:= )
"
RDEPEND="${DEPEND}"

CMAKE_BUILD_TYPE="Release"

src_configure() {
	local mycmakeargs=(
		"-DFAIL_ON_WARNINGS=OFF"
		"-DPORTABLE=OFF"
		"-DUSE_RTTI=ON"
		"-DWITH_BZ2=$(usex bzip2 ON OFF)"
		"-DWITH_GFLAGS=$(usex gflags ON OFF)"
		"-DWITH_JEMALLOC=$(usex jemalloc ON OFF)"
		"-DWITH_JNI=OFF"
		"-DWITH_LZ4=$(usex lz4 ON OFF)"
		"-DWITH_SNAPPY=$(usex snappy ON OFF)"
		"-DWITH_TESTS=$(usex test ON OFF)"
		"-DWITH_TOOLS=$(usex tools ON OFF)"
		"-DWITH_ZLIB=$(usex zlib ON OFF)"
		"-DWITH_ZSTD=$(usex zstd ON OFF)"
	)
	cmake-utils_src_configure
}
