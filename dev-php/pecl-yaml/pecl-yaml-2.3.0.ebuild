# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PHP_EXT_NAME="yaml"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
USE_PHP="php8-2 php8-3 php8-4 php8-5"

inherit php-ext-pecl-r3

DESCRIPTION="YAML 1.1 (YAML Ain't Markup Language) serialization for PHP"

LICENSE="MIT"
SLOT="7"
KEYWORDS="~amd64 ~arm64 ~riscv ~x86"

DEPEND="dev-libs/libyaml"
RDEPEND="${DEPEND}"
