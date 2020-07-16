# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit rebar

DESCRIPTION="QuickCheck-inspired property-based testing tool for Erlang"
HOMEPAGE="https://github.com/manopapad/proper"
SRC_URI="https://github.com/manopapad/proper/archive/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm ~ia64 ppc ~sparc x86"

DEPEND=">=dev-lang/erlang-17.1:="
RDEPEND="${DEPEND}"

DOCS=( README.md THANKS )

# tests broken with current erlang 23.x
RESTRICT="test"

src_configure() {
	./configure
}
