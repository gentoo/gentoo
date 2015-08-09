# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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
