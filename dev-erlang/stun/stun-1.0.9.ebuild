# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit rebar

DESCRIPTION="STUN and TURN library for Erlang and Elixir"
HOMEPAGE="https://github.com/processone/stun"
SRC_URI="https://github.com/processone/${PN}/archive/${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ia64 ~ppc ~sparc ~x86"

DEPEND=">=dev-erlang/fast_tls-1.0.9
	>=dev-erlang/p1_utils-1.0.6
	>=dev-lang/erlang-17.1"
RDEPEND="${DEPEND}"

DOCS=( CHANGELOG.md README.md )
