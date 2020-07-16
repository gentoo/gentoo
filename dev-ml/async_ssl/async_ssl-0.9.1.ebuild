# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="An Async-pipe-based interface with OpenSSL."
HOMEPAGE="https://github.com/janestreet/async_ssl"
SRC_URI="https://github.com/janestreet/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	dev-lang/ocaml:=
	dev-ml/async:=
	dev-ml/base:=
	dev-ml/configurator:=
	dev-ml/core:=
	dev-ml/ppx_driver:=
	dev-ml/ppx_jane:=
	dev-ml/stdio:=
	dev-ml/ocaml-ctypes:=
	dev-libs/openssl:0=
	dev-ml/ocaml-migrate-parsetree:=
"
DEPEND="${RDEPEND}
	dev-ml/opam
	dev-ml/jbuilder
"

src_install() {
	opam-installer -i \
		--prefix="${ED}/usr" \
		--libdir="${D}/$(ocamlc -where)" \
		--docdir="${ED}/usr/share/doc/${PF}" \
		${PN}.install || die
}
