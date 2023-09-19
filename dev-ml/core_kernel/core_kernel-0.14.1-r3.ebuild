# Copyright 1999-2022 Gentoo Authors
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
	dev-lang/ocaml:=
	<dev-ml/jst-config-0.15.0
	dev-ml/base:=
	=dev-ml/base_bigstring-0.14*:=
	dev-ml/base_quickcheck:=
	dev-ml/bin_prot:=
	dev-ml/fieldslib:=
	dev-ml/jane-street-headers:=
	dev-ml/ocaml-migrate-parsetree:=
	=dev-ml/ppx_assert-0.14*:=
	=dev-ml/ppx_base-0.14*:=
	=dev-ml/ppx_hash-0.14*:=
	dev-ml/ppx_inline_test:=
	dev-ml/ppx_jane:=
	dev-ml/ppx_sexp_conv:=
	dev-ml/ppx_sexp_message:=
	dev-ml/splittable_random:=
	dev-ml/sexplib:=
	dev-ml/stdio:=
	dev-ml/time_now:=
	dev-ml/typerep:=
	dev-ml/variantslib:=
"
DEPEND="${RDEPEND}"
