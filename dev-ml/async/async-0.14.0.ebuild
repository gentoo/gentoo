# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

DESCRIPTION="Jane Street Capital's asynchronous execution library"
HOMEPAGE="https://github.com/janestreet/async"
SRC_URI="https://github.com/janestreet/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="+ocamlopt"

# Need qtest_lib, netkit_sockets
# Unpackaged test deps
RESTRICT="test"

RDEPEND="
	dev-ml/async_extra:=
	dev-ml/async_kernel:=
	dev-ml/async_unix:=
	dev-ml/core:=
	dev-ml/core_kernel:=
	dev-ml/ppx_jane:=
	dev-ml/textutils:=
"
DEPEND="${RDEPEND}"
