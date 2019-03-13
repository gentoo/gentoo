# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN=${P#-bin}
MY_P=${MY_PN}-${PV}

DESCRIPTION="A sophisticated build-tool for Erlang projects that follows OTP principles"
HOMEPAGE="https://github.com/erlang/rebar3"

SRC_URI="https://github.com/erlang/rebar3/releases/download/${PV}/rebar3"

LICENSE="Apache-2.0"
SLOT="3"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-lang/erlang"
DEPEND=""

S="${WORKDIR}"

QA_PREBUILT="/usr/bin/rebar3"

src_unpack() {
	cp -v "${DISTDIR}/${A}" "${S}/" || die
}

src_install() {
	dobin rebar3
}
