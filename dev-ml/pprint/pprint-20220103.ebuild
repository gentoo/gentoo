# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="A pretty-printing combinator library and rendering engine"
HOMEPAGE="https://github.com/fpottier/pprint/"
SRC_URI="https://github.com/fpottier/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2 LGPL-2-with-linking-exception"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="+ocamlopt"
