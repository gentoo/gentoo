# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit rebar

DESCRIPTION="JSON NIFs for Erlang"
HOMEPAGE="https://github.com/davisp/jiffy"
SRC_URI="https://github.com/davisp/${PN}/archive/${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="MIT BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~ia64 ppc ~sparc x86"

DEPEND=">=dev-lang/erlang-17.1"
RDEPEND="${DEPEND}"

DOCS=( README.md )
