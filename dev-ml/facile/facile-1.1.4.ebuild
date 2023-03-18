# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="OCaml constraint programming library on integer & integer set finite domains"
HOMEPAGE="http://opti.recherche.enac.fr/"
SRC_URI="https://github.com/Emmanuel-PLF/${PN}/releases/download/${PV}/${P}.tbz"

LICENSE="LGPL-2.1"
SLOT="0/${PV}"

KEYWORDS="~amd64 arm64 ~ppc ~ppc64 ~x86"
IUSE="+ocamlopt"

RDEPEND=">=dev-lang/ocaml-4:=[ocamlopt?]"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${P}-dune.patch )
