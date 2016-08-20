# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit rebar

DESCRIPTION="Erlang port of Hamcrest"
HOMEPAGE="https://github.com/hyperthunk/hamcrest-erlang"
SRC_URI="https://github.com/basho/hamcrest-erlang/archive/${PV}-basho.tar.gz"
S="${WORKDIR}/hamcrest-erlang-${PV}-basho"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ia64 ~ppc ~sparc ~x86"
IUSE="test"

CDEPEND=">=dev-lang/erlang-17.1"
DEPEND="${CDEPEND}
	test? ( >=dev-erlang/proper-1.1 )"
RDEPEND="${CDEPEND}"

DOCS=( NOTES  README.markdown TODO.md )

# Override with EAPI default because it's missing hamcrest.app.src and doesn't
# have any deps.
src_prepare() {
	default
}

src_test() {
	rebar_remove_deps test.config
	erebar -C test.config compile ct
}
