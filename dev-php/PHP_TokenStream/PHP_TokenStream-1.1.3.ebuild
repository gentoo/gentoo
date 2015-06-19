# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/PHP_TokenStream/PHP_TokenStream-1.1.3.ebuild,v 1.7 2014/08/10 20:58:07 slyfox Exp $

EAPI=4

PEAR_PV="1.1.3"
PHP_PEAR_PKG_NAME="PHP_TokenStream"

inherit php-pear-r1

DESCRIPTION="Wrapper around PHP's tokenizer extension"
HOMEPAGE="http://pear.phpunit.de"
SRC_URI="http://pear.phpunit.de/get/PHP_TokenStream-1.1.3.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 hppa x86"
IUSE=""

DEPEND="dev-lang/php[tokenizer]
	>=dev-php/pear-1.9.4"
RDEPEND="${DEPEND}"
