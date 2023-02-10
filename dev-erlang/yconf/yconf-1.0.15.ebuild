# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit rebar

DESCRIPTION="YAML configuration processor"
HOMEPAGE="https://github.com/processone/yconf"
SRC_URI="https://github.com/processone/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm ~ia64 ~ppc ~sparc ~x86"

DEPEND="
	>=dev-lang/erlang-17.1
	>=dev-erlang/fast_yaml-1.0.36
"
RDEPEND="${DEPEND}"

DOCS=( CHANGELOG.md README.md )
