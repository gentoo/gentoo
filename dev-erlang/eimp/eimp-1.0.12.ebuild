# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit rebar

DESCRIPTION="Erlang Image Manipulation Process"
HOMEPAGE="https://github.com/processone/eimp"
SRC_URI="https://github.com/processone/eimp/archive/${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=dev-lang/erlang-17.1
	>=dev-erlang/p1_utils-1.0.16
	media-libs/gd[png,jpeg,webp]"
DEPEND="${RDEPEND}"

DOCS=( CHANGELOG.md README.md )

src_test() {
	mkdir -p .eunit/priv/bin || die
	cp priv/bin/eimp .eunit/priv/bin/ || die
	rebar_src_test
}
