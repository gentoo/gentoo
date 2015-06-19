# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/PEAR-PEAR_Info/PEAR-PEAR_Info-1.9.2-r3.ebuild,v 1.1 2015/04/15 01:05:11 grknight Exp $

EAPI=5

inherit php-pear-r1

DESCRIPTION="Show Information about your PEAR install and its packages"
LICENSE="PHP-3.01"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~sparc ~x86"
IUSE="minimal"

DEPEND="dev-lang/php:*[pcre(+)]
		dev-php/PEAR-Console_Getargs"
