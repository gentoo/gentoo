# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Interpreter and compiler to be compatible with Arity/Prolog32"
HOMEPAGE="https://github.com/sasagawa888/nprolog/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/sasagawa888/${PN}.git"
else
	SRC_URI="https://github.com/sasagawa888/nprolog/archive/v${PV}.tar.gz
		-> ${P}.tar.gz"

	KEYWORDS="amd64 ~x86"
fi

LICENSE="BSD-2"
SLOT="0"

PATCHES=( "${FILESDIR}/${PN}-3.22-ncursesw.patch" )

DOCS=( README{,-ja}.md document )

src_prepare() {
	if [[ -f edlog ]] ; then
		rm edlog || die
	fi

	default
}

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}"
}

src_install() {
	exeinto /usr/bin
	doexe npl

	insinto "/usr/share/${PN}"
	doins -r example library

	einstalldocs
}
