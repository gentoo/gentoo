# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="A lock-free thread-safe integer keyed hash table"
HOMEPAGE="https://github.com/ocaml-multicore/thread-table"
SRC_URI="https://github.com/ocaml-multicore/${PN}/releases/download/${PV}/${P}.tbz"

LICENSE="ISC"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE="+ocamlopt test"

RDEPEND=">=dev-lang/ocaml-4.08:=[ocamlopt?]"
BDEPEND="test? ( >=dev-ml/alcotest-1.7.0:* )"
DEPEND="${RDEPEND}"

RESTRICT="!test? ( test )"
