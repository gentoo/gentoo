# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit findlib

DESCRIPTION="Logging infrastructure for OCaml"
HOMEPAGE="https://erratique.ch/software/logs https://github.com/dbuenzli/logs"
SRC_URI="https://erratique.ch/software/logs/releases/${P}.tbz"

LICENSE="ISC"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE="+fmt cli +lwt test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-ml/result:=[ocamlopt]
	dev-lang/ocaml:=[ocamlopt]
	fmt? ( dev-ml/fmt:= )
	cli? ( dev-ml/cmdliner:=[ocamlopt] )
	lwt? ( dev-ml/lwt:= )
"
DEPEND="${RDEPEND}
	dev-ml/opam
	dev-ml/topkg
	dev-ml/ocamlbuild
	dev-ml/findlib
	test? ( dev-ml/mtime )
"

src_prepare() {
	default
	sed -i \
		-e "/test\/test_fmt/d" \
		-e "/test\/test_formatter/d" \
		-e "/test\/tool/d" \
		-e "/test\/test_lwt/d" \
		pkg/pkg.ml \
		|| die
}

src_compile() {
	ocaml pkg/pkg.ml build \
		--with-js_of_ocaml false \
		--with-fmt $(usex fmt true false) \
		--with-cmdliner $(usex cli true false) \
		--with-lwt $(usex fmt true false) \
		--tests $(usex test true false) \
		--with-base-threads true \
		|| die
}

src_test() {
	ocaml pkg/pkg.ml test || die
}

src_install() {
	opam-installer -i \
		--prefix="${ED}/usr" \
		--libdir="${D}/$(ocamlc -where)" \
		--docdir="${ED}/usr/share/doc/${PF}" \
		${PN}.install || die
	dodoc CHANGES.md README.md
}
