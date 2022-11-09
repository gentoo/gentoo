# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

H=c98b014c131b6c0b147b852902953dd6c5771603

inherit dune

DESCRIPTION="Computer-Aided Cryptographic Proofs"
HOMEPAGE="https://github.com/EasyCrypt/easycrypt"

if [[ "${PV}" == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/EasyCrypt/${PN}.git"
else
	SRC_URI="https://github.com/EasyCrypt/${PN}/archive/${H}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-${H}"
fi

LICENSE="CeCILL-B CeCILL-C"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="+ocamlopt"

RDEPEND="
	>=dev-lang/ocaml-4.08.0:=[ocamlopt?]
	>=sci-mathematics/why3-1.4:= <sci-mathematics/why3-1.5:=
	dev-ml/batteries:=
	dev-ml/camlzip:=
	dev-ml/dune-build-info:=
	dev-ml/dune-site:=
	dev-ml/ocaml-inifiles:=
	dev-ml/pcre-ocaml:=
	dev-ml/yojson:=
	dev-ml/zarith:=
"
DEPEND="${RDEPEND}"

src_prepare() {
	local theories="[\"$(ocamlc -where)/easycrypt/theories\"]"
	sed -i "s|EcRelocate\.Sites\.theories|${theories}|g" src/ec.ml || die

	default
}
