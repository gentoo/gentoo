# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=FONKIE
DIST_VERSION=2.28
inherit perl-module

DESCRIPTION="Read the CDDB entry for an audio CD in your drive"
SRC_URI+=" http://armin.emx.at/cddb/${PN}-${DIST_VERSION}.tar.gz"
HOMEPAGE="http://armin.emx.at/cddb/ https://metacpan.org/release/CDDB_get"

# Bug #721294
LICENSE="|| ( Artistic ( GPL-1+ GPL-2 ) )"
SLOT="2"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
