# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

DESCRIPTION="Time-zone handling for OCaml"
HOMEPAGE="https://github.com/janestreet/timezone"
SRC_URI="https://github.com/janestreet/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="amd64 arm arm64 ppc ppc64 x86"
IUSE="+ocamlopt"

RDEPEND="
	dev-ml/core_kernel:=
	dev-ml/ppx_jane:=
"
DEPEND="${RDEPEND}"
