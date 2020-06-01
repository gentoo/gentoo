# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit bash-completion-r1

DESCRIPTION="A sophisticated build-tool for Erlang projects that follows OTP principles"
HOMEPAGE="https://github.com/rebar/rebar"
SRC_URI="https://github.com/rebar/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

RDEPEND="dev-lang/erlang:="
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}/rebar-erlang23.diff" )

src_test() {
	emake xref
}

src_install() {
	dobin rebar
	dodoc rebar.config.sample THANKS
	dobashcomp priv/shell-completion/bash/${PN}
}
