# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/pecl-mongo/pecl-mongo-1.6.3.ebuild,v 1.3 2015/08/02 18:37:35 ago Exp $

EAPI=5

PHP_EXT_NAME="mongo"

USE_PHP="php5-6 php5-5 php5-4"

inherit php-ext-pecl-r2

DESCRIPTION="MongoDB database driver"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
