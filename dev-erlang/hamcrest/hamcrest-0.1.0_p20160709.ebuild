# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit rebar

DESCRIPTION="Erlang port of Hamcrest"
HOMEPAGE="https://github.com/hyperthunk/hamcrest-erlang"
SRC_URI="https://dev.gentoo.org/~hanno/distfiles/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~ia64 ppc ~sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

COMMON_DEPEND=">=dev-lang/erlang-17.1"
DEPEND="${COMMON_DEPEND}
	test? ( >=dev-erlang/proper-1.2 )"
RDEPEND="${COMMON_DEPEND}"

DOCS=( NOTES README.markdown TODO.md )

# Override with EAPI default because it's missing hamcrest.app.src and doesn't
# have any deps.
src_prepare() {
	default
}

src_test() {
	rebar_remove_deps test.config
	erebar -C test.config compile ct
}
