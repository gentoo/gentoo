# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit rebar

DESCRIPTION="ProcessOne SIP server component"
HOMEPAGE="https://github.com/processone/esip"
SRC_URI="https://github.com/processone/${PN}/archive/${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86"

DEPEND=">=dev-erlang/fast_tls-1.0.0
	>=dev-erlang/stun-1.0.0
	>=dev-erlang/p1_utils-1.0.2
	>=dev-lang/erlang-17.1"
RDEPEND="${DEPEND}"

DOCS=( CHANGELOG.md  README.md )

src_prepare() {
	rebar_src_prepare
	rebar_fix_include_path stun

	# ebin contains lonely .gitignore file asking for removal.
	rm -r "${S}/ebin"
}
