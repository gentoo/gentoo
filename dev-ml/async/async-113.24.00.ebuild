# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

OASIS_BUILD_DOCS=1
OASIS_BUILD_TESTS=1

inherit oasis

DESCRIPTION="Jane Street Capital's asynchronous execution library"
HOMEPAGE="http://www.janestreet.com/ocaml"
SRC_URI="http://ocaml.janestreet.com/ocaml-core/${PV%.*}/files/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="examples"

RDEPEND=">=dev-lang/ocaml-4.02.0:=
	>=dev-ml/async_kernel-${PV}:=
	>=dev-ml/async_unix-${PV}:=
	dev-ml/bin-prot:=
	dev-ml/core:=
	dev-ml/fieldslib:=
	dev-ml/ppx_assert:=
	dev-ml/ppx_bench:=
	dev-ml/ppx_driver:=
	dev-ml/ppx_expect:=
	dev-ml/ppx_inline_test:=
	dev-ml/ppx_jane:=
	dev-ml/sexplib:=
	dev-ml/typerep:=
	dev-ml/variantslib:=
"
DEPEND="${RDEPEND} dev-ml/opam"

src_configure() {
	emake setup.exe
	OASIS_SETUP_COMMAND="./setup.exe" oasis_src_configure
}

src_compile() {
	emake
}

src_install() {
	opam-installer -i \
		--prefix="${ED}/usr" \
		--libdir="${D}/$(ocamlc -where)" \
		--docdir="${ED}/usr/share/doc/${PF}" \
		${PN}.install || die
	dodoc CHANGES.md
	if use examples ; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
