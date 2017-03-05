# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit rebar

DESCRIPTION="Fast Expat based Erlang XML parsing library"
HOMEPAGE="https://github.com/processone/fast_xml"
SRC_URI="https://github.com/processone/${PN}/archive/${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm ~ia64 ppc ~sparc x86"
IUSE="test"

RDEPEND=">=dev-erlang/p1_utils-1.0.0
	>=dev-lang/erlang-17.1
	<dev-lang/erlang-19
	dev-libs/expat"
DEPEND="${RDEPEND}
	test? ( >=dev-lang/elixir-1.1 )"

DOCS=( CHANGELOG.md  README.md )
