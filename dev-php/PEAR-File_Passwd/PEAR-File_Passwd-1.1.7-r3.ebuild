# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/PEAR-File_Passwd/PEAR-File_Passwd-1.1.7-r3.ebuild,v 1.1 2015/04/23 20:25:13 grknight Exp $

EAPI="5"

inherit php-pear-r1

DESCRIPTION="Manipulate many kinds of password files"

LICENSE="PHP-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE=""

DEPEND="dev-lang/php:*[pcre(+)]"
RDEPEND="${DEPEND}"
