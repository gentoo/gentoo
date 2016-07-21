# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PHP_EXT_NAME="mailparse"
DOCS=( README )

USE_PHP="php5-5 php5-6"

inherit php-ext-pecl-r3

KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

DESCRIPTION="PHP extension for parsing RFC822 and RFC2045 (MIME) messages"
LICENSE="PHP-2.02"
SLOT="0"
IUSE=""

for _target in ${USE_PHP}; do
	_slot=${_target/php}
	_slot=${_slot/-/.}
	_PHPUSEDEPEND="${_PHPUSEDEPEND}
	php_targets_${_target}? ( dev-lang/php:${_slot}[unicode] )"
done
unset slot target

RDEPEND="${_PHPUSEDEPEND}"
unset _PHPUSEDEPEND
DEPEND="${RDEPEND}
	dev-util/re2c"
