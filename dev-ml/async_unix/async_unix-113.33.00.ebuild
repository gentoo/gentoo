# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

OASIS_BUILD_DOCS=1

inherit oasis

DESCRIPTION="Jane Street Capital's asynchronous execution library (unix)"
HOMEPAGE="http://www.janestreet.com/ocaml"
SRC_URI="http://ocaml.janestreet.com/ocaml-core/${PV%.*}/files/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	>=dev-lang/ocaml-4.02.0:=
	dev-ml/async_kernel:=
	dev-ml/bin-prot:=
	dev-ml/ocaml-ctypes:=
	>=dev-ml/fieldslib-109.20.00:=
	dev-ml/ppx_assert:=
	dev-ml/ppx_bench:=
	dev-ml/ppx_driver:=
	dev-ml/ppx_expect:=
	dev-ml/ppx_inline_test:=
	dev-ml/ppx_jane:=
	>=dev-ml/sexplib-109.20.00:=
	dev-ml/typerep:=
	dev-ml/variantslib:=
	dev-ml/core:=
"
DEPEND="${RDEPEND} dev-ml/opam"

src_prepare() {
	has_version '>=dev-lang/ocaml-4.03' && epatch "${FILESDIR}/oc43.patch"
}

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
}
