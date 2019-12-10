# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit rebar

DESCRIPTION="Mocking library for Erlang"
HOMEPAGE="https://github.com/eproxus/meck"
SRC_URI="https://github.com/eproxus/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm ~ia64 ppc ~sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

CDEPEND=">=dev-lang/erlang-17.1"
DEPEND="${CDEPEND}
	test? ( >=dev-erlang/hamcrest-0.1.0_p20150103 )"
RDEPEND="${CDEPEND}"

DOCS=( CHANGELOG NOTICE README.md )

src_prepare() {
	rebar_src_prepare
	rebar_remove_deps test.config
}

src_test() {
	erebar -C test.config compile eunit
}
