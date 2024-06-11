# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit rebar

DESCRIPTION="QuickCheck-inspired property-based testing tool for Erlang"
HOMEPAGE="https://github.com/proper-testing/proper"
SRC_URI="https://github.com/proper-testing/proper/archive/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~arm ~sparc x86"

DEPEND=">=dev-lang/erlang-17.1:="
RDEPEND="${DEPEND}"

# tests broken with current erlang 23.x
RESTRICT="test"
