# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

DESCRIPTION="Protocol aware version negotiation for OCaml"
HOMEPAGE="https://github.com/janestreet/protocol_version_header"
SRC_URI="https://github.com/janestreet/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="+ocamlopt"

RDEPEND="
	dev-ml/core_kernel:=
	dev-ml/ppx_jane:=
"
DEPEND="${RDEPEND}"
