# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

DESCRIPTION="An OCaml lexer generator for Unicode"
HOMEPAGE="https://github.com/ocaml-community/sedlex"
SRC_URI="https://github.com/ocaml-community/${PN}/archive/v${PV}.tar.gz
			-> ${P}.tar.gz"

FILES=( DerivedCoreProperties extracted/DerivedGeneralCategory PropList )
for file in ${FILES[@]} ; do
	SRC_URI+=" https://www.unicode.org/Public/12.1.0/ucd/${file}.txt
				-> ${P}-${file##*/}.txt"
done

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="+ocamlopt"

DEPEND="
	dev-ml/gen:=
	dev-ml/ppxlib:=
	dev-ml/uchar:=
"
RDEPEND="${DEPEND}"

src_compile() {
	ebegin "Building"
	dune build @install --display short --profile release \
		--ignore-promoted-rules
	eend $? || die
}

dune_src_test() {
	ebegin "Testing"
	dune runtest --display short --profile release \
		--ignore-promoted-rules
	eend $? || die
}
