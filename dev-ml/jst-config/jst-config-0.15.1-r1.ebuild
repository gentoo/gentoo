# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="Compile-time configuration for Jane Street libraries"
HOMEPAGE="https://github.com/janestreet/jst-config"
SRC_URI="https://github.com/janestreet/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="amd64 arm ~arm64 ~ppc ~ppc64 ~riscv x86"
IUSE="+ocamlopt"

DEPEND="
	dev-ml/base:=
	dev-ml/dune-configurator:=
	dev-ml/ppxlib:=
	dev-ml/ppx_assert:=
	dev-ml/ppx_compare:=
	dev-ml/ppx_here:=
	dev-ml/ppx_sexp_conv:=
	dev-ml/stdio:=
"
RDEPEND="${DEPEND}"
