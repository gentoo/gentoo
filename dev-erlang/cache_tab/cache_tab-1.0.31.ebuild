# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit rebar3

DESCRIPTION="In-memory cache Erlang and Elixir library"
HOMEPAGE="https://github.com/processone/cache_tab"
SRC_URI="https://github.com/processone/${PN}/archive/${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~sparc ~x86"

DEPEND="
	>=dev-lang/erlang-17.1
	>=dev-erlang/p1_utils-1.0.26
"
RDEPEND="${DEPEND}"

DOCS=( CHANGELOG.md README.md )
