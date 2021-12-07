# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

DESCRIPTION="Binding to libuv: cross-platform asynchronous I/O"
HOMEPAGE="https://github.com/aantron/luv"
SRC_URI="https://github.com/aantron/${PN}/releases/download/${PV}/${P}.tar.gz"

SLOT="0/${PV}"
LICENSE="MIT"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE="+ocamlopt test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/libuv:=
	dev-ml/ocaml-ctypes:=
	dev-ml/result:=
"
DEPEND="${RDEPEND}"
BDEPEND="test? ( dev-ml/alcotest )"
