# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit rebar

MY_PN="erlang_protobuffs"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Google's Protocol Buffers for Erlang"
HOMEPAGE="https://github.com/basho/erlang_protobuffs"
SRC_URI="https://github.com/basho/${MY_PN}/archive/${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm ~ia64 ppc ~sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

CDEPEND=">=dev-lang/erlang-17.1"
DEPEND="${CDEPEND}
	test? (
		>=dev-erlang/meck-0.8.2
		>=dev-erlang/proper-1.1
	)"
RDEPEND="${CDEPEND}"

DOCS=( AUTHORS  ChangeLog  README.md RELNOTES.md )

S="${WORKDIR}/${MY_P}"

src_test() {
	./scripts/generate_emakefile.escript || die
	erebar ct
	# FIXME: 1 test fails, reported upstream:
	# FIXME: https://github.com/basho/erlang_protobuffs/issues/100
	# FIXME: erebar eunit
}
