# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="OCaml bindings for ZeroMQ 4.x"
HOMEPAGE="https://github.com/issuu/ocaml-zmq/"

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/issuu/ocaml-zmq.git"
else
	SRC_URI="https://github.com/issuu/ocaml-zmq/archive/${PV}.tar.gz
		-> ocaml-zmq-${PV}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi
S="${WORKDIR}"/ocaml-zmq-${PV}

LICENSE="MIT"
SLOT="0/${PV}"
IUSE="+ocamlopt test"
RESTRICT="!test? ( test )"

RDEPEND="
	net-libs/zeromq:=
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-ml/dune-configurator
	test? ( dev-ml/ounit2 )
"

src_compile() {
	dune-compile ${DUNE_PKG_NAME}
}

src_test() {
	dune-test ${DUNE_PKG_NAME}
}
