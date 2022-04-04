# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="Stream and Genlex libraries for use with Camlp4 and Camlp5"
HOMEPAGE="https://github.com/ocaml/camlp-streams"
SRC_URI="https://github.com/ocaml/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="LGPL-2-with-linking-exception"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

IUSE="+ocamlopt"
