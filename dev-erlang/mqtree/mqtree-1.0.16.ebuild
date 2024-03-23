# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit rebar

DESCRIPTION="Index tree for MQTT topic filters"
HOMEPAGE="https://github.com/processone/mqtree"
SRC_URI="https://github.com/processone/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ia64 ~ppc ~sparc ~x86"

DEPEND="
	>=dev-lang/erlang-17.5
	>=dev-erlang/p1_utils-1.0.25
"
RDEPEND="${DEPEND}"

DOCS=( README.md )
