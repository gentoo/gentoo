# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="Cooperative light-weight thread library for OCaml"
HOMEPAGE="https://github.com/ocsigen/lwt_log"
SRC_URI="https://github.com/ocsigen/${PN}/archive/${PV}.tar.gz
	-> ${P}.tar.gz"

SLOT="0/${PV}"
LICENSE="LGPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="+ocamlopt"

RDEPEND="dev-ml/lwt:="
DEPEND="${RDEPEND}"
