# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/PEAR-HTTP/PEAR-HTTP-1.4.1-r2.ebuild,v 1.9 2015/02/28 14:06:38 ago Exp $

EAPI=5

inherit php-pear-r1 eutils

DESCRIPTION="Miscellaneous HTTP utilities"
LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86"
IUSE=""

src_prepare() {
	# fix nasty DOS linebreaks
	edos2unix HTTP.php
}
