# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PHP_EXT_NAME="zstd"
USE_PHP="php8-2 php8-3 php8-4 php8-5"

inherit php-ext-pecl-r3

DESCRIPTION="PHP extension for compression and decompression with Zstandard library"
HOMEPAGE="https://pecl.php.net/package/zstd
	https://github.com/kjdev/php-ext-zstd"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~riscv"

RDEPEND="app-arch/zstd:="
BDEPEND="virtual/pkgconfig"
DEPEND="${RDEPEND}"

PHP_EXT_ECONF_ARGS=( --with-libzstd )

src_prepare() {
	rm -r zstd || die "failed to remove bundled zstd"
	php-ext-source-r3_src_prepare
}

src_test() {
	SKIP_ONLINE_TESTS=1 php-ext-source-r3_src_test
}
