# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils

DESCRIPTION="A source-based package manager for OCaml"
HOMEPAGE="http://opam.ocaml.org/"
LICENSE="LGPL-3-with-linking-exception"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

if [[ ${PV} != 9999 ]]; then
	SRC_URI="https://github.com/ocaml/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
else
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ocaml/opam.git"
fi

RDEPEND="dev-lang/ocaml:=
	|| ( net-misc/wget net-misc/curl )
	dev-ml/extlib:=
	dev-ml/ocaml-re:=
	dev-ml/ocamlgraph:=
	dev-ml/cmdliner:=
	dev-ml/cudf:=
	>=dev-ml/dose3-5:=
	dev-ml/uutf:=
	dev-ml/jsonm:=
"
DEPEND="${RDEPEND}
	dev-ml/findlib
	test? ( dev-vcs/git )
"

src_prepare() {
	epatch "${FILESDIR}/stublibs.patch"
}

src_compile() {
	emake -j1
	cd doc
	emake man
}

src_test() {
	EMAIL=foo@bar.com emake -j1 tests
}

src_install() {
	default
	emake DESTDIR="${D}" OPAMINSTALLER_FLAGS="--prefix=\"${ED}/usr\" --libdir=\"${D}/$(ocamlc -where)\"" libinstall
}
