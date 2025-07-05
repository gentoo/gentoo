# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_PHP="php8-2 php8-3"

inherit php-ext-pecl-r3

unset SRC_URI
PHP_EXT_PECL_PKG_V="${PHP_EXT_PECL_PKG}-${PV/_/}"

if [[ ${PV} == 9999* ]]; then
	EGIT_REPO_URI="https://github.com/kjdev/php-ext-brotli.git"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${PHP_EXT_PECL_PKG_V}"
	EGIT_SUBMODULES=()
	inherit git-r3
else
	SRC_URI="https://pecl.php.net/get/${PHP_EXT_PECL_PKG_V}.tgz -> ${P}.tgz"
	KEYWORDS="~amd64"
fi

DESCRIPTION="Brotli compression extension for PHP"
HOMEPAGE+=" https://github.com/kjdev/php-ext-brotli"

LICENSE="MIT"
SLOT="0"

RDEPEND="app-arch/brotli:="
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PHP_EXT_ECONF_ARGS=(
	--with-libbrotli
)
