# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PHP_EXT_NAME="imagick"
USE_PHP="php8-2 php8-3 php8-4 php8-5"

# https://github.com/Imagick/imagick/issues/626
PHP_EXT_NEEDED_USE="-debug"

inherit php-ext-pecl-r3

DESCRIPTION="PHP wrapper for the ImageMagick library"
HOMEPAGE="https://pecl.php.net/package/imagick https://github.com/Imagick/imagick"
LICENSE="PHP-3.01"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"
IUSE="examples test"
RESTRICT="!test? ( test )"

# The USE="-openmp" requirement on media-gfx/imagemagick (from bug
# 547922) has been dropped in v3.8.0 due to popular demand. With any
# luck, enough time has passed that these segfaults no longer occur.
RDEPEND="media-gfx/imagemagick:="

# While it does support skipping tests, the test suite for pecl-imagick
# doesn't accomodate many imagemagick build options. We could curate a
# list of tests to remove in src_prepare() based on what USE flags are
# set, but in my opinion, it would break too frequently.
DEPEND="
	${RDEPEND}
	test? ( media-gfx/imagemagick:=[fontconfig,-hardened,hdri,jpeg,png,svg,truetype,xml] )
"

PHP_EXT_ECONF_ARGS="--with-imagick=${EPREFIX}/usr"

src_prepare() {
	# Test fails with ImageMagick >=7.1.2
	#
	#	https://github.com/Imagick/imagick/issues/737
	#
	rm "${S}/tests/024-ispixelsimilar.phpt" || die

	php-ext-source-r3_src_prepare
}

src_install() {
	php-ext-pecl-r3_src_install
	php-ext-source-r3_addtoinifiles "imagick.skip_version_check" "1"
}
