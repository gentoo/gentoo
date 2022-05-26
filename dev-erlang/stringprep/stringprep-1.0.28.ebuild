# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit rebar

DESCRIPTION="Fast Stringprep implementation for Erlang and Elixir"
HOMEPAGE="https://github.com/processone/stringprep"
SRC_URI="https://github.com/processone/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0 tcltk"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ia64 ~ppc ~sparc ~x86"

DEPEND="
	>=dev-lang/erlang-17.1
	>=dev-erlang/p1_utils-1.0.25
"
RDEPEND="${DEPEND}"

DOCS=( CHANGELOG.md README.md )
