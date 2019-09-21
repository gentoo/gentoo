# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

DESCRIPTION="A deliberately simple workload generator for POSIX systems"
HOMEPAGE="https://people.seas.harvard.edu/~apw/stress"
SRC_URI="https://people.seas.harvard.edu/~apw/${PN}/${P}.tar.gz -> ${P}-r1.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 arm ~mips ppc ppc64 sparc x86"
IUSE="static"

src_configure() {
	local myeconfargs=(
		$(use_enable static)
	)

	econf "${myeconfargs[@]}"
}
