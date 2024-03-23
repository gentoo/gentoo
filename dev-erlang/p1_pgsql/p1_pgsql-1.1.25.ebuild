# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit rebar

DESCRIPTION="Pure Erlang PostgreSQL driver"
HOMEPAGE="https://github.com/processone/p1_pgsql"
SRC_URI="
	https://github.com/processone/${PN}/archive/${PV}.tar.gz
	-> ${P}.tar.gz
"

LICENSE="ErlPL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ia64 ~ppc ~sparc ~x86"

DEPEND="
	>=dev-erlang/xmpp-1.8.1
	>=dev-lang/erlang-17.1
"
RDEPEND="${DEPEND}"

DOCS=( CHANGELOG.md README.md )
