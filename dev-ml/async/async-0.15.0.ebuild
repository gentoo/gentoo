# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="Jane Street Capital's asynchronous execution library"
HOMEPAGE="https://github.com/janestreet/async"
SRC_URI="https://github.com/janestreet/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="+ocamlopt"

# Need qtest_lib, netkit_sockets
# Unpackaged test deps
RESTRICT="test"

RDEPEND="
	dev-ml/async_rpc_kernel:${SLOT}
	dev-ml/async_unix:${SLOT}
	dev-ml/textutils:${SLOT}
"
DEPEND="${RDEPEND}"
