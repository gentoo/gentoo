# Copyright 2019-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="Library to parse and type-check an extension of the SMT-LIB 2 standard"
HOMEPAGE="https://github.com/OCamlPro-Coquera/psmt2-frontend"
SRC_URI="https://github.com/OCamlPro-Coquera/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="amd64 ~x86"
IUSE="+ocamlopt test"
RESTRICT="!test? ( test )"

RDEPEND=">=dev-ml/menhir-20181006:="
DEPEND="${RDEPEND}"
BDEPEND="test? (
	dev-ml/ppx_expect
	dev-ml/ppx_inline_test
)"
