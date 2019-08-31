# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit rebar

DESCRIPTION="Fast Yaml native library for Erlang and Elixir"
HOMEPAGE="https://github.com/processone/fast_yaml"
SRC_URI="https://github.com/processone/${PN}/archive/${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ia64 ~ppc ~sparc ~x86"

DEPEND=">=dev-erlang/p1_utils-1.0.16
	>=dev-lang/erlang-18.0
	dev-libs/libyaml"
RDEPEND="${DEPEND}"

DOCS=( CHANGELOG.md README.md )

# from upstream:
# https://github.com/processone/fast_yaml/commit/e789f68895f71b7ad31057177810ca0161bf790e
PATCHES=(
	"${FILESDIR}/${P}-dont-escape-simple-quote.patch"
)
