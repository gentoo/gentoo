# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="Automatic theorem prover"
HOMEPAGE="https://alt-ergo.ocamlpro.com
	https://github.com/OCamlPro/alt-ergo/"

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/OCamlPro/${PN}.git"
else
	SRC_URI="https://github.com/OCamlPro/${PN}/archive/${PV}.tar.gz
		-> ${P}.tar.gz"
	KEYWORDS="amd64"
fi

LICENSE="CeCILL-C"
SLOT="0/${PV}"
IUSE="examples gui +ocamlopt"
REQUIRED_USE="ocamlopt"

RDEPEND="
	>=dev-lang/ocaml-4.09.0:=[ocamlopt=]
	>=sci-mathematics/psmt2-frontend-0.4.0:=

	<dev-ml/ocplib-simplex-0.5:=
	>=dev-ml/cmdliner-1.1.0:=
	>=dev-ml/menhir-20181006:=
	dev-ml/camlzip:=
	dev-ml/num:=
	dev-ml/stdlib-shims:=
	dev-ml/zarith:=
	gui? (
		dev-ml/lablgtk:3
		dev-ml/lablgtk-sourceview:3
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-ml/dune-build-info
	dev-ml/dune-configurator
"

PATCHES=( "${FILESDIR}"/${PN}-2.4.3-dune.patch )

OCAML_SUBPACKAGES=(
	alt-ergo-lib
	alt-ergo-parsers
	alt-ergo
)

src_prepare() {
	default

	if use gui ; then
		OCAML_SUBPACKAGES+=( altgr-ergo )
	fi
}

src_configure() {
	sh ./configure --prefix /usr --libdir=/usr/$(get_libdir) || die
}

src_compile() {
	dune-compile ${OCAML_SUBPACKAGES[@]}
}

src_install() {
	dune-install ${OCAML_SUBPACKAGES[@]}

	use examples && dodoc -r examples
}
