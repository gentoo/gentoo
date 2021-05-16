# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

DESCRIPTION="Cram like framework for OCaml"
HOMEPAGE="https://github.com/janestreet/ppx_expect"
SRC_URI="https://github.com/janestreet/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="amd64 arm arm64 ppc ppc64 x86"
IUSE="+ocamlopt test"
RESTRICT="!test? ( test )"

DEPEND="
	>=dev-ml/base-0.14.0:=
	>=dev-ml/ppx_here-0.14.0:=
	>=dev-ml/ppx_inline_test-0.14.1:=
	>=dev-ml/stdio-0.14.0:=
	>=dev-ml/ppxlib-0.18.0:=
		>=dev-ml/ocaml-compiler-libs-0.11.0:=
		>=dev-ml/ocaml-migrate-parsetree-2.0.0:=
			dev-ml/cinaps:=
	dev-ml/re:=
"
RDEPEND="${DEPEND}"
DEPEND="${DEPEND}
	test? (
		dev-ml/ppx_jane
	)"
# https://bugs.gentoo.org/749291#c2
RESTRICT=test

PATCHES=( "${FILESDIR}"/${P}-ppxlib-0.18.0.patch )
