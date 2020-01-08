# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit findlib opam

DESCRIPTION="Redis bindings for OCaml"
HOMEPAGE="http://0xffea.github.io/ocaml-redis/ https://github.com/0xffea/ocaml-redis/"
SRC_URI="https://github.com/0xffea/ocaml-redis/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-lang/ocaml:=
	dev-ml/ocaml-re:=
	dev-ml/uuidm:=
"
DEPEND="${RDEPEND}
	dev-ml/jbuilder
	test? ( dev-ml/ounit dev-db/redis dev-ml/lwt )"

src_compile() {
	jbuilder build -p redis || die
}

src_test() {
	einfo "Starting test redis server"
	local port=4567
	/usr/sbin/redis-server --port ${port} &
	local rpid=$!
	export OCAML_REDIS_TEST_PORT=${port}
	sleep 1
	jbuilder runtest || { kill ${rpid}; die; }
	kill ${rpid} || die
}

src_install() {
	opam_src_install redis
}
