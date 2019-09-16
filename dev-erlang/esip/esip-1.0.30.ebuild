# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit rebar

DESCRIPTION="ProcessOne SIP server component"
HOMEPAGE="https://github.com/processone/esip"
SRC_URI="https://github.com/processone/${PN}/archive/${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ia64 ~ppc ~sparc ~x86"

DEPEND=">=dev-lang/erlang-17.1
	>=dev-erlang/fast_tls-1.1.2
	>=dev-erlang/stun-1.0.29
	>=dev-erlang/p1_utils-1.0.16"
RDEPEND="${DEPEND}"

DOCS=( CHANGELOG.md README.md )

src_prepare() {
	rebar_src_prepare
	rebar_fix_include_path stun

	# ebin contains lonely .gitignore file asking for removal.
	rm -r "${S}/ebin" || die
}
