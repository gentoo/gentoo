# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

DESCRIPTION="Micro-benchmarking library for OCaml"
HOMEPAGE="https://github.com/janestreet/core_bench"
SRC_URI="https://github.com/janestreet/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="amd64 arm ~arm64 ppc ppc64 x86"
IUSE="+ocamlopt"

DEPEND="
	>=dev-ml/core-0.14.0:=
	>=dev-ml/core_kernel-0.14.0:=
	>=dev-ml/ppx_jane-0.14.0:=
	dev-ml/textutils:=
	>=dev-ml/re-1.8.0:=
"
RDEPEND="${DEPEND}"
