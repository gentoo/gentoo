# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils

DESCRIPTION="Unicode library used by the courier mail server"
HOMEPAGE="http://www.courier-mta.org/"
SRC_URI="mirror://sourceforge/courier/${P}.tar.bz2"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ia64 ~mips ppc ppc64 sparc x86"
IUSE=""

src_install() {
	default
	prune_libtool_files
	dodoc AUTHORS ChangeLog README
}
