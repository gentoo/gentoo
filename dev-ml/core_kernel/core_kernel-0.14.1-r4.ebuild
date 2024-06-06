# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

DESCRIPTION="System-independent part of Core"
HOMEPAGE="https://github.com/janestreet/core_kernel"
SRC_URI="https://github.com/janestreet/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1-with-linking-exception"
SLOT="0/${PV}"
KEYWORDS="amd64 arm arm64 ~ppc ppc64 x86"
IUSE="+ocamlopt"

# Wants quickcheck_deprecated for now
RESTRICT="test"

RDEPEND="
	<dev-lang/ocaml-4.12:=
	<dev-ml/jst-config-0.15.0
	<dev-ml/base-0.15:=
	=dev-ml/base_bigstring-0.14*:=
	<dev-ml/base_quickcheck-0.15:=
	dev-ml/bin_prot:0/0.14.0
	dev-ml/fieldslib:0/0.14.0
	dev-ml/jane-street-headers:0/0.14.0
	dev-ml/ocaml-migrate-parsetree:=
	=dev-ml/ppx_assert-0.14*:=
	=dev-ml/ppx_base-0.14*:=
	=dev-ml/ppx_hash-0.14*:=
	dev-ml/ppx_inline_test:0/0.14.1
	dev-ml/ppx_jane:0/0.14.0
	<dev-ml/ppx_sexp_conv-0.15:=
	<dev-ml/ppx_sexp_message-0.15:=
	dev-ml/splittable_random:0/0.14.0
	dev-ml/sexplib:0/0.14.0
	dev-ml/stdio:0/0.14.0
	dev-ml/time_now:0/0.14.0
	dev-ml/typerep:0/0.14.0
	dev-ml/variantslib:0/0.14.0
"
DEPEND="${RDEPEND}"
