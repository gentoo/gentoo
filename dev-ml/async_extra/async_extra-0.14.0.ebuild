# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

DESCRIPTION="Jane Street Capital's asynchronous execution library (extra)"
HOMEPAGE="https://github.com/janestreet/async_extra"
SRC_URI="https://github.com/janestreet/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="+ocamlopt"

RDEPEND="
	dev-ml/async_kernel:=
	dev-ml/async_rpc_kernel:=
	dev-ml/async_unix:=
	dev-ml/core_kernel:=
	dev-ml/ppx_jane:=
"
DEPEND="${RDEPEND}"
