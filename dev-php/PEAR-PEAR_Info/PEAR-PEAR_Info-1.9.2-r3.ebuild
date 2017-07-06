# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit php-pear-r1

DESCRIPTION="Show Information about your PEAR install and its packages"
LICENSE="PHP-3.01"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="minimal"

DEPEND="dev-lang/php:*[pcre(+)]
		dev-php/PEAR-Console_Getargs"
