# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A sophisticated build-tool for Erlang projects that follows OTP principles"
HOMEPAGE="https://rebar3.org https://github.com/erlang/rebar3"
SRC_URI="https://github.com/erlang/rebar3/releases/download/${PV}/rebar3 -> ${P}"
S="${WORKDIR}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~x86"

RDEPEND="dev-lang/erlang"

QA_PREBUILT="usr/bin/rebar3"

src_install() {
	newbin "${DISTDIR}"/${P} rebar3
}
