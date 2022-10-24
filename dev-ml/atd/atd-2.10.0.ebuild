# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="Static types for JSON APIs"
HOMEPAGE="https://github.com/ahrefs/atd/"
SRC_URI="https://github.com/ahrefs/atd/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="+ocamlopt"
RESTRICT="test"

RDEPEND="
	>=dev-lang/ocaml-4.08:=[ocamlopt?]
	>=dev-ml/cmdliner-1.1.1:=
	>=dev-ml/yojson-2.0.2:=
	dev-ml/biniou:=
	dev-ml/easy-format:=
	dev-ml/menhir:=
	dev-ml/re:=
"
DEPEND="${RDEPEND}"

src_install() {
	dune-install atd                            \
				 atdgen                         \
				 atdgen-codec-runtime           \
				 atdgen-runtime                 \
				 atdj                           \
				 atdpy                          \
				 atds                           \
				 atdts
	dodoc CHANGES.md CONTRIBUTING.md README.md
}
