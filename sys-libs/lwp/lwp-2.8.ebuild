# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit ltprune

DESCRIPTION="Light-weight process library (used by Coda)"
HOMEPAGE="http://www.coda.cs.cmu.edu/"
SRC_URI="http://www.coda.cs.cmu.edu/pub/lwp/src/${P}.tar.xz"

LICENSE="LGPL-2.1"
SLOT="1"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ~mips ppc ppc64 sparc x86"
IUSE=""

PATCHES=(
	"${FILESDIR}"/${P}-ia64.patch
)

src_configure() {
	econf --disable-static
}

src_install() {
	default
	prune_libtool_files
}
