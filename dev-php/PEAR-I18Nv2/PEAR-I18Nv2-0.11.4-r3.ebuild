# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/PEAR-I18Nv2/PEAR-I18Nv2-0.11.4-r3.ebuild,v 1.1 2015/04/15 02:09:08 grknight Exp $

EAPI=5

inherit php-pear-r1

DESCRIPTION="Internationalization - basic support to localize your application"
LICENSE="PHP-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""
DEPEND="dev-lang/php:*[iconv,pcre(+)]"
RDEPEND="${DEPEND}"
