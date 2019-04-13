# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
PHP_EXT_NAME="imagick"

MY_COMMIT="d57a444766a321fa226266f51f1f42ee2cc29cc7"

USE_PHP="php5-6 php7-0 php7-1 php7-2 php7-3"

S="${WORKDIR}/imagick-${MY_COMMIT}"

inherit php-ext-source-r3

KEYWORDS="~amd64 ~x86"

DESCRIPTION="PHP wrapper for the ImageMagick library"
HOMEPAGE="https://pecl.php.net/imagick https://github.com/mkoppanen/imagick"
SRC_URI="https://github.com/mkoppanen/imagick/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"
LICENSE="PHP-3.01"
SLOT="0"
IUSE="examples test"

# imagemagick[-openmp] is needed wrt bug 547922 and upstream
# https://github.com/mkoppanen/imagick#openmp
RDEPEND=">=media-gfx/imagemagick-6.2.4:=[-openmp]"
DEPEND="${RDEPEND}
	test? ( >=media-gfx/imagemagick-6.2.4:=[jpeg,png,truetype] )"

PATCHES=( "${FILESDIR}"/${PN}-3.4.3-tsrm_ls-is-undeclared.patch )

PHP_EXT_ECONF_ARGS="--with-imagick=${EPREFIX%/}/usr"
