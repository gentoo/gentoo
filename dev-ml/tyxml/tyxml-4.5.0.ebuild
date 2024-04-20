# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="A library for building correct HTML and SVG documents"
HOMEPAGE="https://github.com/ocsigen/tyxml"
SRC_URI="https://github.com/ocsigen/${PN}/releases/download/${PV}/${P}.tbz"

LICENSE="LGPL-2.1-with-linking-exception"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+ocamlopt test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-ml/markup:=
	dev-ml/ppxlib:=
	dev-ml/uutf:=
	dev-ml/re:="
DEPEND="${RDEPEND}"
BDEPEND="test? (
	dev-ml/alcotest
	dev-ml/reason
)"

PATCHES=( "${FILESDIR}"/${P}-gentoo.patch )
