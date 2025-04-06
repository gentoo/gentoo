# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit rebar

DESCRIPTION="STUN and TURN library for Erlang and Elixir"
HOMEPAGE="https://github.com/processone/stun"
SRC_URI="https://github.com/processone/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~sparc ~x86"

DEPEND="
	>=dev-erlang/fast_tls-1.1.22
	>=dev-erlang/p1_utils-1.0.26
"
RDEPEND="${DEPEND}"

DOCS=( CHANGELOG.md README.md )
