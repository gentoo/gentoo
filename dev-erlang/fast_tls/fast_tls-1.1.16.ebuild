# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit rebar

DESCRIPTION="TLS/SSL native driver for Erlang and Elixir"
HOMEPAGE="https://github.com/processone/fast_tls"
SRC_URI="https://github.com/processone/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ia64 ~ppc ~sparc ~x86"
IUSE=""

DEPEND="
	>=dev-erlang/p1_utils-1.0.25
	dev-libs/openssl:0=
"
RDEPEND="${DEPEND}"

DOCS=( CHANGELOG.md README.md )
