# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Interpreter and compiler to be compatible with Arity/Prolog32"
HOMEPAGE="https://github.com/sasagawa888/nprolog/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/sasagawa888/${PN}"
else
	SRC_URI="https://github.com/sasagawa888/${PN}/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.gh.tar.gz"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="BSD-2"
SLOT="0"
IUSE="doc"

DOCS=( README{,-ja}.md )

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

	if use doc ; then
		DOCS+=( document )

		docompress -x "/usr/share/doc/${PF}/document"
	fi

	einstalldocs
}
