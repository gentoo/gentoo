# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DUNE_PKG_NAME="sqlite3"
inherit dune

DESCRIPTION="SQLite3 bindings for OCaml"
HOMEPAGE="http://mmottl.github.io/sqlite3-ocaml/"
SRC_URI="https://github.com/mmottl/sqlite3-ocaml/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/sqlite3-ocaml-${PV}"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="+ocamlopt test"
RESTRICT="!test? ( test )"

RDEPEND=">=dev-db/sqlite-3.3.3"
BDEPEND="
	>=dev-lang/ocaml-4.06
	dev-ml/dune-configurator
"
DEPEND="${RDEPEND}
	test? (
		dev-ml/ppx_inline_test
	)
"
