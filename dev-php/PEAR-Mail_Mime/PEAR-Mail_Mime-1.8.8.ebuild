# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/PEAR-Mail_Mime/PEAR-Mail_Mime-1.8.8.ebuild,v 1.10 2014/03/19 13:46:33 ago Exp $

EAPI="5"

inherit php-pear-r1

DESCRIPTION="Provides classes to deal with creation and manipulation of mime messages"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 ~s390 ~sh sparc x86"
IUSE=""

PDEPEND="dev-php/PEAR-Mail_mimeDecode"
