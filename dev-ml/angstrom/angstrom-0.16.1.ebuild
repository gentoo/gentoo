# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit dune

DESCRIPTION="Parser combinators built for speed and memory-efficiency"
HOMEPAGE="https://github.com/inhabitedtype/angstrom"
SRC_URI="https://github.com/inhabitedtype/${PN}/archive/${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 arm64 ~x86"
IUSE="+ocamlopt test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-ml/async:=[ocamlopt?]
	dev-ml/bigstringaf:=[ocamlopt?]
	dev-ml/lwt:=[ocamlopt?]
"
DEPEND="${RDEPEND}"
BDEPEND="test? ( dev-ml/alcotest )"
