# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="Jane Street Capital's asynchronous execution library"
HOMEPAGE="https://github.com/janestreet/async"
SRC_URI="https://github.com/janestreet/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64 ~arm64 ~ppc ~ppc64"
IUSE="+ocamlopt"

# Need qtest_lib, netkit_sockets
# Unpackaged test deps
RESTRICT="test"

RDEPEND="
	>=dev-lang/ocaml-5
	dev-ml/async_kernel:${SLOT}[ocamlopt?]
	dev-ml/async_log:${SLOT}[ocamlopt?]
	dev-ml/async_rpc_kernel:${SLOT}[ocamlopt?]
	dev-ml/async_unix:${SLOT}[ocamlopt?]
	dev-ml/core:${SLOT}[ocamlopt?]
	dev-ml/core_kernel:${SLOT}[ocamlopt?]
	dev-ml/core_unix:${SLOT}[ocamlopt?]
	dev-ml/ppx_jane:${SLOT}[ocamlopt?]
	dev-ml/textutils:${SLOT}[ocamlopt?]
"
DEPEND="${RDEPEND}"
BDEPEND=">=dev-ml/dune-3.11"
