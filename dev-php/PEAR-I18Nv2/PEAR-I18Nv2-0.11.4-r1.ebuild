# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/PEAR-I18Nv2/PEAR-I18Nv2-0.11.4-r1.ebuild,v 1.8 2014/08/10 20:50:36 slyfox Exp $

EAPI="2"

inherit php-pear-r1

DESCRIPTION="Internationalization - basic support to localize your application"
LICENSE="PHP-3"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86"
IUSE=""
DEPEND="|| ( <dev-lang/php-5.3[pcre,iconv] >=dev-lang/php-5.3[iconv] )"
