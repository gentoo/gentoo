# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN=${PN}3

inherit bash-completion-r1

DESCRIPTION="A sophisticated build-tool for Erlang projects that follows OTP principles"
HOMEPAGE="https://www.rebar3.org https://github.com/erlang/rebar3"
SRC_URI="https://github.com/erlang/${MY_PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${MY_PN}-${PV}

LICENSE="Apache-2.0 MIT BSD"
SLOT="3"
KEYWORDS="~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="test"

RESTRICT="!test? ( test )"

RDEPEND="
	dev-lang/erlang[ssl]
	!dev-util/rebar-bin
"
DEPEND="${RDEPEND}"

src_compile() {
	./bootstrap || die
}

src_test() {
	./rebar3 ct || die
}

src_install() {
	dobashcomp apps/rebar/priv/shell-completion/bash/${MY_PN}
	dobin ${MY_PN}
	dodoc rebar.config.sample
	doman manpages/${MY_PN}.1

	insinto /usr/share/fish/completion
	newins apps/rebar/priv/shell-completion/fish/${MY_PN}.fish ${MY_PN}

	insinto /usr/share/zsh/site-functions
	doins apps/rebar/priv/shell-completion/zsh/_${MY_PN}
}
