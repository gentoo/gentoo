# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

DESCRIPTION="Ppx rewriter that records top-level module startup times"
HOMEPAGE="https://github.com/janestreet/ppx_module_timer"
SRC_URI="https://github.com/janestreet/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="amd64 arm arm64 ~ppc ppc64 ~riscv x86"
IUSE="+ocamlopt"

DEPEND="
	>=dev-ml/base-0.14.0:=
	>=dev-ml/ppx_base-0.14.0:=
	>=dev-ml/stdio-0.14.0:=
	>=dev-ml/time_now-0.14.0:=
	>=dev-ml/ppxlib-0.18.0:=
	>=dev-ml/ocaml-compiler-libs-0.11.0:=
	>=dev-ml/ocaml-migrate-parsetree-2.0.0:=
	dev-ml/cinaps:=
	dev-ml/sexplib0:=
"
RDEPEND="${DEPEND}"
