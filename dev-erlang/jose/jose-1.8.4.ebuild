# Copyright 1999-2018 Gentoo Foundation
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

DEPEND=">=dev-lang/erlang-17.1
	>=dev-erlang/base64url-0.1"
RDEPEND="${DEPEND}"

DOCS=( CHANGELOG.md  README.md )

# TODO: jose has test suite, but it require lots of dependencies. It may not be
# TODO: urgent, but it would be nice to have those sooner or later.
RESTRICT=test

S="${WORKDIR}/erlang-${P}"
