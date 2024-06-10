# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit rebar

DESCRIPTION="Erlang Redis client"
HOMEPAGE="https://github.com/wooga/eredis"
SRC_URI="https://github.com/wooga/${PN}/archive/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~sparc ~x86"

DEPEND=">=dev-lang/erlang-17.1"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS CHANGELOG.md README.md )

# Needs running redis instance at 127.0.0.1:6379.
RESTRICT=test
