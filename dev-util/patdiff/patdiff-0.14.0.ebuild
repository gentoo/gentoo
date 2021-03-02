# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

DESCRIPTION="Colored patience diffs with word-level refinement"
HOMEPAGE="https://github.com/janestreet/patdiff"
SRC_URI="https://github.com/janestreet/patdiff/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+ocamlopt"

RDEPEND="
	>=dev-lang/ocaml-4.08.0:=
	dev-ml/core:=
	dev-ml/core_kernel:=
	dev-ml/patience_diff:0/$(ver_cut 1-2)
	dev-ml/ppx_jane:=
	dev-ml/pcre-ocaml:=
	>=dev-ml/re-1.8.0
"
