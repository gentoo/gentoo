# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit rebar

DESCRIPTION="ProcessOne SIP server component"
HOMEPAGE="https://github.com/processone/esip"
SRC_URI="https://github.com/processone/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ia64 ~ppc ~sparc ~x86"

DEPEND="
	>=dev-erlang/fast_tls-1.1.16
	>=dev-erlang/stun-1.2.10
	>=dev-erlang/p1_utils-1.0.25
"
RDEPEND="${DEPEND}"

DOCS=( CHANGELOG.md README.md )

src_prepare() {
	rebar_src_prepare
	rebar_fix_include_path stun
}
