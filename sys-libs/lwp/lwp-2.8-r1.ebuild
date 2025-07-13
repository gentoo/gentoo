# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Light-weight process library (used by Coda)"
HOMEPAGE="http://www.coda.cs.cmu.edu/"
SRC_URI="http://www.coda.cs.cmu.edu/pub/lwp/src/${P}.tar.xz"

LICENSE="LGPL-2.1"
SLOT="1"
KEYWORDS="~alpha amd64 ~hppa ~mips ppc ppc64 sparc x86"

PATCHES=(
	"${FILESDIR}"/"${P}"-ia64.patch
	"${FILESDIR}"/"${P}"-bool.patch
)

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
