# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit bash-completion-r1

DESCRIPTION="A sophisticated build-tool for Erlang projects that follows OTP principles"
HOMEPAGE="https://github.com/erlang/rebar3"
SRC_URI="https://github.com/erlang/rebar3/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ia64 ~ppc ppc64 ~sparc ~x86"
IUSE="bash-completion"

RDEPEND="
	dev-lang/erlang
"
DEPEND="${RDEPEND}"

src_compile() {
	./bootstrap || die "bootstrap failed"
}

src_test() {
	./rebar3 ct || die "tests failed"
}

src_install() {
	dobin rebar3
	dodoc rebar.config.sample THANKS
	use bash-completion && dobashcomp priv/shell-completion/bash/${PN}
}
