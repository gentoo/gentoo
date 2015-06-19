# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-calculators/transcalc/transcalc-0.14-r1.ebuild,v 1.3 2012/08/04 22:16:43 bicatali Exp $

EAPI=4
inherit eutils

DESCRIPTION="Microwave and RF transmission line calculator"
HOMEPAGE="http://transcalc.sourceforge.net"
SRC_URI="http://transcalc.sourceforge.net/${P}.tar.gz"

LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="x11-libs/gtk+:2"
RDEPEND="${DEPEND}"

src_prepare() {
	# respect flags
	sed -i -e 's|^CFLAGS=|#CFLAGS=|g' configure || die
	# patch from debian
	epatch "${FILESDIR}"/${P}-fd-perm.patch
	# syntax errors
	sed -i \
		-e 's/ythesize/ynthesize/g' \
		src/{setup_menu.c,help.h} docs/transcalc.sgml README || die
}
