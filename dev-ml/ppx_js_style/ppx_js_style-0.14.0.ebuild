# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

DESCRIPTION="Code style checker for Jane Street Packages"
HOMEPAGE="https://github.com/janestreet/ppx_js_style"
SRC_URI="https://github.com/janestreet/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="amd64 arm arm64 ppc ppc64 x86"
IUSE="+ocamlopt"

DEPEND="
	>=dev-ml/base-0.14.0:=
	dev-ml/findlib:=
	dev-ml/octavius:=
	>=dev-ml/ppxlib-0.18.0:=
		>=dev-ml/ocaml-compiler-libs-0.11.0:=
		>=dev-ml/ocaml-migrate-parsetree-2.0.0:=
			dev-ml/cinaps:=
	"
RDEPEND="${DEPEND}"
