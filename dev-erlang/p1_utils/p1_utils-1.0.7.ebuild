# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit rebar

DESCRIPTION="Erlang utility modules from ProcessOne"
HOMEPAGE="https://github.com/processone/p1_utils"
SRC_URI="https://github.com/processone/${PN}/archive/${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ia64 ~ppc ~sparc ~x86"

DEPEND=">=dev-lang/erlang-17.1"
RDEPEND="${DEPEND}"

DOCS=( CHANGELOG.md  README.md )
