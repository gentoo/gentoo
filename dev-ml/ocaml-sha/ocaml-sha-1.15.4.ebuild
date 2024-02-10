# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DUNE_PKG_NAME=sha

inherit dune

MYP=sha-${PV}
DESCRIPTION="Binding to the SHA cryptographic functions"
HOMEPAGE="https://github.com/djs55/ocaml-sha/"
SRC_URI="https://github.com/djs55/${PN}/releases/download/v${PV}/${MYP}.tbz"

LICENSE="ISC"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="+ocamlopt test"
RESTRICT="!test? ( test )"

RDEPEND="dev-ml/stdlib-shims:="
DEPEND="${RDEPEND}"
BDEPEND="test? ( dev-ml/ounit2 )"

S="${WORKDIR}"/${MYP}
