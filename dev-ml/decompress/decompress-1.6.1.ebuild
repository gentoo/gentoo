# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="Pure OCaml implementation of Zlib"
HOMEPAGE="https://github.com/mirage/decompress"
SRC_URI="https://github.com/mirage/decompress/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="+ocamlopt test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-ml/dune-configurator:=[ocamlopt?]
	dev-ml/optint:=[ocamlopt?]
	dev-ml/cmdliner:=[ocamlopt?]
	dev-ml/checkseum:=[ocamlopt?]
"
DEPEND="${RDEPEND}"
BDEPEND="
	test? (
		dev-ml/alcotest
		dev-ml/astring
		dev-ml/bos
		dev-ml/bstr
		dev-ml/camlzip
		dev-ml/findlib
		dev-ml/fmt
		dev-ml/fpath
		dev-ml/ocaml-base64
		dev-ml/rresult
	)
"

src_prepare() {
	default
	# depends on unpackaged crowbar
	rm -rf fuzz || die
}
