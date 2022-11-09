# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PHP_EXT_NAME="imagick"
USE_PHP="php7-4 php8-0 php8-1"

inherit php-ext-pecl-r3

KEYWORDS="~amd64 ~arm ~arm64 ~x86"

DESCRIPTION="PHP wrapper for the ImageMagick library"
HOMEPAGE="https://pecl.php.net/package/imagick https://github.com/Imagick/imagick"
LICENSE="PHP-3.01"
SLOT="0"
IUSE="examples test"
RESTRICT="!test? ( test )"

# imagemagick[-openmp] is needed wrt bug 547922 and upstream
# https://github.com/Imagick/imagick#openmp
RDEPEND=">=media-gfx/imagemagick-6.2.4:=[-openmp]"
DEPEND="${RDEPEND}
	test? ( >=media-gfx/imagemagick-6.2.4:=[hdri,jpeg,png,svg,truetype,xml] )"

PHP_EXT_ECONF_ARGS="--with-imagick=${EPREFIX}/usr"

src_install() {
	php-ext-pecl-r3_src_install

	php-ext-source-r3_addtoinifiles "imagick.skip_version_check" "1"
}
