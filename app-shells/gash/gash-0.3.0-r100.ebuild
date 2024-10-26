# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GUILE_COMPAT=( 2-2 3-0 )

inherit guile-single

DESCRIPTION="POSIX-compatible shell written in Guile Scheme"
HOMEPAGE="https://savannah.nongnu.org/projects/gash/"
SRC_URI="mirror://nongnu/${PN}/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="strip"

REQUIRED_USE="${QUILE_REQUIRED_USE}"

RDEPEND="${GUILE_DEPS}"
DEPEND="${RDEPEND}"
BDEPEND="sys-apps/texinfo"

src_prepare() {
	guile-single_src_prepare

	sed -i -e "s|guile|${GUILE}|" tests/temporary-assignments.org || die
}
