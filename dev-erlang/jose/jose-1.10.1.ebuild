# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit rebar

DESCRIPTION="JSON Object Signing and Encryption (JOSE) for Erlang and Elixir"
HOMEPAGE="https://github.com/potatosalad/erlang-jose"
SRC_URI="https://github.com/potatosalad/erlang-jose/archive/${PV}.tar.gz
	-> erlang-${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~ia64 ~ppc ~sparc x86"
IUSE=""

DEPEND=">=dev-lang/erlang-19.0"
RDEPEND="${DEPEND}"

DOCS=( ALGORITHMS.md CHANGELOG.md README.md examples/KEY-GENERATION.md )

# TODO: jose has test suite, but it require lots of dependencies. It may not be
# TODO: urgent, but it would be nice to have those sooner or later.
RESTRICT=test

S="${WORKDIR}/erlang-${P}"

src_prepare() {
	# disable warnings_as_errors for erlang 23 compatibiltiy
	# https://github.com/potatosalad/erlang-jose/issues/87
	sed -i -e 's|warnings_as_errors||g' \
		-e 's|debug_info,|debug_info|g' rebar.config
	rebar_src_prepare
}
