# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="Jane Street's alternative to the standard library"
HOMEPAGE="https://github.com/janestreet/core"
SRC_URI="https://github.com/janestreet/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64 ~arm64 ~ppc ~ppc64"
IUSE="+ocamlopt"

RDEPEND="
	>=dev-lang/ocaml-5
	dev-ml/base:${SLOT}[ocamlopt?]
	dev-ml/base_bigstring:${SLOT}[ocamlopt?]
	dev-ml/base_quickcheck:${SLOT}[ocamlopt?]
	dev-ml/bin_prot:${SLOT}[ocamlopt?]
	dev-ml/fieldslib:${SLOT}[ocamlopt?]
	dev-ml/jane-street-headers:${SLOT}[ocamlopt?]
	dev-ml/jst-config:${SLOT}[ocamlopt?]
	dev-ml/ppx_assert:${SLOT}[ocamlopt?]
	dev-ml/ppx_base:${SLOT}[ocamlopt?]
	dev-ml/ppx_diff:${SLOT}[ocamlopt?]
	dev-ml/ppx_hash:${SLOT}[ocamlopt?]
	dev-ml/ppx_inline_test:${SLOT}[ocamlopt?]
	dev-ml/ppx_jane:${SLOT}[ocamlopt?]
	dev-ml/ppx_optcomp:${SLOT}[ocamlopt?]
	dev-ml/ppx_sexp_conv:${SLOT}[ocamlopt?]
	dev-ml/ppx_sexp_message:${SLOT}[ocamlopt?]
	dev-ml/sexplib:${SLOT}[ocamlopt?]
	dev-ml/splittable_random:${SLOT}[ocamlopt?]
	dev-ml/stdio:${SLOT}[ocamlopt?]
	dev-ml/time_now:${SLOT}[ocamlopt?]
	dev-ml/typerep:${SLOT}[ocamlopt?]
	dev-ml/variantslib:${SLOT}[ocamlopt?]
"
DEPEND="${RDEPEND}"
BDEPEND=">=dev-ml/dune-3.11"
