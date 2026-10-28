# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="Adler-32, CRC32 and CRC32-C implementation"
HOMEPAGE="https://github.com/mirage/checkseum"
SRC_URI="https://github.com/mirage/checkseum/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="+ocamlopt test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-ml/dune-configurator:=[ocamlopt?]
	dev-ml/optint:=[ocamlopt?]
"
DEPEND="${RDEPEND}"
BDEPEND="
	test? (
		dev-ml/alcotest
		dev-ml/bos
		dev-ml/astring
		dev-ml/fmt
		dev-ml/fpath
		dev-ml/rresult
		dev-ml/findlib
	)
"
