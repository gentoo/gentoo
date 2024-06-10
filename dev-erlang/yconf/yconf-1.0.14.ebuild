# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit rebar

DESCRIPTION="YAML configuration processor"
HOMEPAGE="https://github.com/processone/yconf"
SRC_URI="https://github.com/processone/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~sparc ~x86"

DEPEND="
	>=dev-lang/erlang-17.1
	>=dev-erlang/fast_yaml-1.0.34
"
RDEPEND="${DEPEND}"

DOCS=( CHANGELOG.md README.md )
