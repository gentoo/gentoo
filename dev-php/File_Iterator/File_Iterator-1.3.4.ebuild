# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PHP_PEAR_DOMAIN="pear.phpunit.de"
PHP_PEAR_CHANNEL="${FILESDIR}/channel.xml"
PHP_PEAR_PKG_NAME="File_Iterator"
inherit php-pear-r2

DESCRIPTION="FilterIterator implementation that filters files based on a list of suffixes"
LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~hppa x86"
IUSE=""
HOMEPAGE="https://github.com/sebastianbergmann/php-file-iterator
	https://phpunit.de"
SRC_URI="http://${PHP_PEAR_URI}/get/${PEAR_P}.tgz"
DOCS=( ChangeLog.markdown README.markdown )
