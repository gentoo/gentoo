# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/pecl-svn/pecl-svn-1.0.2-r1.ebuild,v 1.1 2014/09/30 01:18:40 grknight Exp $

EAPI=5

PHP_EXT_NAME="svn"

USE_PHP="php5-6 php5-5 php5-4"

inherit php-ext-pecl-r2

KEYWORDS="~amd64 ~x86"

DESCRIPTION="PHP Bindings for the Subversion Revision control system"
LICENSE="PHP-3.01"
SLOT="0"
IUSE=""

DEPEND="dev-vcs/subversion"
RDEPEND="${DEPEND}"
