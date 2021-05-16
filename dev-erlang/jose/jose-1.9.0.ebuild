# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit rebar

DESCRIPTION="JSON Object Signing and Encryption (JOSE) for Erlang and Elixir"
HOMEPAGE="https://github.com/potatosalad/erlang-jose"
SRC_URI="https://github.com/potatosalad/erlang-jose/archive/${PV}.tar.gz
	-> erlang-${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-lang/erlang-19.0
	>=dev-erlang/base64url-1.0"
RDEPEND="${DEPEND}"

DOCS=( ALGORITHMS.md CHANGELOG.md README.md examples/KEY-GENERATION.md )

# TODO: jose has test suite, but it require lots of dependencies. It may not be
# TODO: urgent, but it would be nice to have those sooner or later.
RESTRICT=test

S="${WORKDIR}/erlang-${P}"
