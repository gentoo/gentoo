# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit rebar

DESCRIPTION="XMPP parsing and serialization library on top of Fast XML"
HOMEPAGE="https://github.com/processone/xmpp"
SRC_URI="https://github.com/processone/${PN}/archive/${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc"

RDEPEND=">=dev-erlang/ezlib-1.0.7
	>=dev-erlang/fast_tls-1.1.5
	>=dev-erlang/fast_xml-1.1.40
	>=dev-erlang/p1_utils-1.0.18
	>=dev-erlang/stringprep-1.0.19
	>=dev-erlang/idna-6.0.0"
DEPEND="${RDEPEND}"

DOCS=( CHANGELOG.md README.md )

src_prepare() {
	rebar_src_prepare
	rebar_fix_include_path fast_xml
}
