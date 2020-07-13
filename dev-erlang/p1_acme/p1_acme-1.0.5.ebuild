# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit rebar

DESCRIPTION="ACME client library for Erlang"
HOMEPAGE="https://github.com/processone/p1_acme"
SRC_URI="https://github.com/processone/${PN}/archive/${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~sparc"

DEPEND=">=dev-lang/erlang-17.1
	>=dev-erlang/jiffy-1.0.1
	>=dev-erlang/yconf-1.0.4
	>=dev-erlang/idna-6.0.0
	>=dev-erlang/jose-1.9.0
	>=dev-erlang/base64url-1.0"
RDEPEND="${DEPEND}"

DOCS=( CHANGELOG.md README.md )

src_prepare() {
	rebar_src_prepare
	# otherwise it wants to fetch base64url from git
	sed -ri 's/\+\+ \[\{base64url.*//' rebar.config.script
}
