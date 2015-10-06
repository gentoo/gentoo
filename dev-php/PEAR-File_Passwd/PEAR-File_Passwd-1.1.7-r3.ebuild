# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit php-pear-r1

DESCRIPTION="Manipulate many kinds of password files"

LICENSE="PHP-3"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 ~s390 ~sh sparc x86"
IUSE=""

DEPEND="dev-lang/php:*[pcre(+)]"
RDEPEND="${DEPEND}"
