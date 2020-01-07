# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Littlewood-Richardson Calculator"
HOMEPAGE="https://sites.math.rutgers.edu/~asbuch/lrcalc/"
SRC_URI="${HOMEPAGE}${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0/1"
KEYWORDS="~amd64 ~x86 ~ppc-macos ~x64-macos ~x86-macos"
IUSE="static-libs test"
RESTRICT="!test? ( test )"

PATCHES=( "${FILESDIR}/${PN}-1.2-includes.patch" )

src_configure(){
	econf $(use_enable static-libs static)
}

src_install(){
	default
	find "${ED}" -name '*.la' -delete || die
}
