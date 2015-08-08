# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Determines where a given nameserver gets its information from"
HOMEPAGE="http://www.mavetju.org/unix/general.php"
SRC_URI="http://www.mavetju.org/download/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 arm hppa ia64 ~ppc ppc64 s390 sparc x86 ~amd64-linux"
IUSE="ipv6"

DOCS=( CHANGES README )

src_configure() {
	econf $(use_enable ipv6)
}
