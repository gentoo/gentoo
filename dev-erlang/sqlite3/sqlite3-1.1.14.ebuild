# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit rebar

MY_PN="erlang-sqlite3"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="SQLite gen_server port for Erlang"
HOMEPAGE="https://github.com/processone/erlang-sqlite3"
SRC_URI="
	https://github.com/processone/${MY_PN}/archive/${PV}.tar.gz
	-> ${P}.tar.gz
"

LICENSE="ErlPL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ia64 ~ppc ~sparc ~x86"

DEPEND=">=dev-lang/erlang-17.1
	dev-db/sqlite:3"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS README.md )

S="${WORKDIR}/${MY_P}"
