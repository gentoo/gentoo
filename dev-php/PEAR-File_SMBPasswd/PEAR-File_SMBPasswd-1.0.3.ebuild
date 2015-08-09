# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"
inherit php-pear-r1

DESCRIPTION="Class for managing SAMBA style password files"
LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86"
IUSE=""
RDEPEND="|| ( <dev-lang/php-5.3[mhash] >=dev-lang/php-5.3 )
		>=dev-php/PEAR-Crypt_CHAP-1.0.0"
