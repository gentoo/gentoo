# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

OASIS_BUILD_TESTS=1
OASIS_BUILD_DOCS=1

inherit oasis

DESCRIPTION="Very lightweight HTTP server using Lwt or Async"
HOMEPAGE="https://github.com/mirage/ocaml-cohttp"
SRC_URI="https://github.com/mirage/ocaml-cohttp/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ISC"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="async javascript +lwt"

DEPEND="
	dev-ml/ocaml-re:=
	dev-ml/stringext:=
	dev-ml/ocaml-uri:=
	dev-ml/fieldslib:=
	dev-ml/sexplib:=
	dev-ml/ppx_fields_conv:=
	dev-ml/ppx_sexp_conv:=
	dev-ml/ocaml-base64:=
	lwt? (
		dev-ml/lwt:=
		dev-ml/logs:=[fmt,lwt]
		dev-ml/cmdliner:=
		dev-ml/ocaml-conduit:=
		dev-ml/ocaml-magic-mime:=
	)
	async? (
		dev-ml/ocaml-conduit:=
		dev-ml/logs:=[fmt]
		dev-ml/ocaml-magic-mime:=
		dev-ml/fmt:=
	)
	javascript? (
		dev-ml/js_of_ocaml:=[ppx]
	)
"
RDEPEND="${DEPEND}"
DEPEND="${DEPEND}
	test? (
		dev-ml/ounit
		dev-ml/alcotest
	)
"
DOCS=( README.md CHANGES DESIGN.md TODO.md )

src_configure() {
	local oasis_configure_opts="
		$(use_enable lwt) $(use_enable lwt lwt-unix)
		$(use_enable async)
		$(use_enable javascript js)
	"
	oasis_src_configure
}
