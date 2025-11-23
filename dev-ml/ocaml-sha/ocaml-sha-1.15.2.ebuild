# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DUNE_PKG_NAME=sha

inherit dune

DESCRIPTION="Binding to the SHA cryptographic functions"
HOMEPAGE="https://github.com/djs55/ocaml-sha/"
SRC_URI="https://github.com/djs55/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ISC"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="+ocamlopt test"
RESTRICT="!test? ( test )"

RDEPEND="dev-ml/stdlib-shims:="
DEPEND="${RDEPEND}"
BDEPEND="test? ( dev-ml/ounit2 )"
