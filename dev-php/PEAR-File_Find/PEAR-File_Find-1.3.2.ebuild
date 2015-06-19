# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/PEAR-File_Find/PEAR-File_Find-1.3.2.ebuild,v 1.6 2015/05/08 08:32:47 ago Exp $

EAPI="5"

inherit php-pear-r1

DESCRIPTION="A class that facillitates the search of filesystems"
LICENSE="PHP-2.02"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86"
IUSE=""

src_unpack() {
	# see bug #476542
	tar xof "${DISTDIR}/${A}" --ignore-zeros
}
