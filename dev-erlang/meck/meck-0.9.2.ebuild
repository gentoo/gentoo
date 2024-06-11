# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit rebar

DESCRIPTION="Mocking library for Erlang"
HOMEPAGE="https://github.com/eproxus/meck"
SRC_URI="https://github.com/eproxus/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm ~sparc x86"

DEPEND=">=dev-lang/erlang-17.1"
RDEPEND="${DEPEND}"

DOCS=( CHANGELOG.md NOTICE README.md )

# Tests need rebar3. The build somewhat works with rebar2.
RESTRICT="test"
