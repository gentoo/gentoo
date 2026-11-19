# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="Stdlib for the Coq/Rocq Prover, used to be part of Coq"
HOMEPAGE="https://github.com/coq/stdlib/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/coq/stdlib"
else
	SRC_URI="https://github.com/coq/stdlib/archive/V${PV}.tar.gz
		-> ${P}.gh.tar.gz"
	S="${WORKDIR}/stdlib-${PV}"

	KEYWORDS="~amd64 ~arm64"
fi

LICENSE="LGPL-2.1"
SLOT="0/${PV}"
IUSE="+ocamlopt"

DUNE_PACKAGES=(
	coq-stdlib
	rocq-stdlib
)

RDEPEND="
	>=sci-mathematics/coq-${PV}:=
"
DEPEND="
	${RDEPEND}
"

src_compile() {
	dune-compile "${DUNE_PACKAGES[@]}"
}

src_install() {
	dune-install "${DUNE_PACKAGES[@]}"
}
