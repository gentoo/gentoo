# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

DESCRIPTION="Pure OCaml library that allows replacing Pervasives with Stdlib before 4.08"
HOMEPAGE="https://github.com/ocaml/stdlib-shims"
SRC_URI="https://github.com/ocaml/${PN}/releases/download/${PV}/${P}.tbz"

LICENSE="LGPL-2.1-with-linking-exception"
SLOT="0"
KEYWORDS="amd64 arm arm64 ppc ppc64 x86"
IUSE="ocamlopt"

DOCS=( "README.md" "CHANGES.md" "LICENSE" )
