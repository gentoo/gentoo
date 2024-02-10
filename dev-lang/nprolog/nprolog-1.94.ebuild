# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Interpreter and compiler to be compatible with Arity/Prolog32"
HOMEPAGE="https://github.com/sasagawa888/nprolog/"
SRC_URI="https://github.com/sasagawa888/nprolog/archive/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 ~x86"

DOCS=( README{,-ja}.md document )

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}"
}

src_install() {
	exeinto /usr/bin
	doexe npl

	insinto /usr/share/${PN}
	doins -r example library

	einstalldocs
}
