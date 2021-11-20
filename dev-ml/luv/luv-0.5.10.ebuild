# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

DESCRIPTION="Binding to libuv: cross-platform asynchronous I/O"
SRC_URI="https://github.com/aantron/${PN}/releases/download/${PV}/${P}.tar.gz"
HOMEPAGE="https://github.com/aantron/luv"

SLOT="0/${PV}"
LICENSE="MIT"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~x86"
IUSE="+ocamlopt"

RDEPEND="dev-ml/ocaml-ctypes"
DEPEND="${RDEPEND}"
BDEPEND=""
