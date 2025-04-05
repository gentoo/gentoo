# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit rebar3

DESCRIPTION="ACME client library for Erlang"
HOMEPAGE="https://github.com/processone/p1_acme"
SRC_URI="https://github.com/processone/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~sparc ~x86"

DEPEND="
	>=dev-lang/erlang-17.1
	>=dev-erlang/jiffy-1.1.1
	>=dev-erlang/yconf-1.0.17
	>=dev-erlang/idna-6.0.0-r1
	>=dev-erlang/jose-1.11.1
	>=dev-erlang/base64url-1.0.1
"
RDEPEND="${DEPEND}"

DOCS=( CHANGELOG.md README.md )
