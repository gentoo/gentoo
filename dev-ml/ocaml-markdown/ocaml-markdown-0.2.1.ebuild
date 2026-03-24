# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DUNE_PKG_NAME="markdown"

inherit dune

DESCRIPTION="Markdown parser and printer in OCaml"
HOMEPAGE="https://github.com/gildor478/ocaml-markdown/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/gildor478/${PN}"
else
	SRC_URI="https://github.com/gildor478/${PN}/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="MIT"
SLOT="0/${PV}"
IUSE="+ocamlopt test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-ml/batteries-2.10:=
	>=dev-ml/tyxml-4.3:=
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	test? (
		>=dev-ml/ounit2-2.0.8
	)
"

DOCS=( CHANGES.md README.md )

src_install() {
	dune_src_install
	einstalldocs
}
