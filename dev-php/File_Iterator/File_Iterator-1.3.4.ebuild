# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

PHP_PEAR_URI="pear.phpunit.de"
PHP_PEAR_CHANNEL="${FILESDIR}/channel.xml"
PHP_PEAR_PN="File_Iterator"
inherit php-pear-lib-r1

DESCRIPTION="FilterIterator implementation that filters files based on a list of suffixes"
LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 hppa x86"
IUSE=""
HOMEPAGE="https://github.com/sebastianbergmann/php-file-iterator"
