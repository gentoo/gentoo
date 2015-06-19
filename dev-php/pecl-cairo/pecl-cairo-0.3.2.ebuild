# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/pecl-cairo/pecl-cairo-0.3.2.ebuild,v 1.1 2013/12/09 21:05:50 mabi Exp $

EAPI="5"

DOCS="TODO"

USE_PHP="php5-4 php5-5"

inherit php-ext-pecl-r2

KEYWORDS="~amd64 ~x86"

DESCRIPTION="Cairo bindings for PHP"
LICENSE="PHP-3.01"
SLOT="0"

DEPEND=">=x11-libs/cairo-1.4[svg]"
RDEPEND="${DEPEND}"

IUSE=""

S="${WORKDIR}/Cairo-${PV}"
PHP_EXT_S="$S"
