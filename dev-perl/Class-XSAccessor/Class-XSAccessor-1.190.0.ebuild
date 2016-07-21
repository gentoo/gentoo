# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=SMUELLER
MODULE_VERSION=1.19
inherit perl-module

DESCRIPTION="Generate fast XS accessors without runtime compilation"

SLOT="0"
KEYWORDS="amd64 ppc x86 ~ppc-aix ~ppc-macos ~x86-solaris"
IUSE=""

DEPEND="
	>=dev-perl/AutoXS-Header-1.01
"
RDEPEND="${DEPEND}
	!dev-perl/Class-XSAccessor-Array
"

SRC_TEST=do
mymake=( OPTIMIZE=${CFLAGS} )
