# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit rebar

DESCRIPTION="Lua in Erlang"
HOMEPAGE="https://github.com/rvirding/luerl"
SRC_URI="https://github.com/rvirding/${PN}/archive/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm ~sparc x86"

DEPEND=">=dev-lang/erlang-17.1"
RDEPEND="${DEPEND}"
