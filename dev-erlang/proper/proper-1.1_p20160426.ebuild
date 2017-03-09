# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit rebar

DESCRIPTION="QuickCheck-inspired property-based testing tool for Erlang"
HOMEPAGE="https://github.com/manopapad/proper"
SRC_URI="https://dev.gentoo.org/~aidecoe/distfiles/${CATEGORY}/${PN}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm ~ia64 ppc ~sparc x86"

DEPEND=">=dev-lang/erlang-17.1
	<dev-lang/erlang-19"
RDEPEND="${DEPEND}"

DOCS=( README.md THANKS )

src_configure() {
	./configure
}
