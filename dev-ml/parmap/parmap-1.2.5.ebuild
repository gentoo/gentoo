# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

MY_PV="${PV/_/-}"
DESCRIPTION="Library to exploit multicore architectures for OCaml programs"
HOMEPAGE="https://www.dicosmo.org/code/parmap/"
SRC_URI="https://github.com/rdicosmo/parmap/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${MY_PV/+/-}"

LICENSE="LGPL-2-with-linking-exception"
SLOT="0/${PV}"
KEYWORDS="amd64 ~arm arm64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="+ocamlopt"

BDEPEND="dev-ml/dune-configurator:="
RDEPEND=">=dev-lang/ocaml-4.03:=[ocamlopt?]"
DEPEND="${RDEPEND}"
