# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

DESCRIPTION="Shared [@@deriving] plugin registry"
HOMEPAGE="https://github.com/diml/ppx_derivers"
SRC_URI="https://github.com/diml/ppx_derivers/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="amd64 arm ~arm64 ppc ppc64 x86"
IUSE="+ocamlopt"

RDEPEND=""
DEPEND="${RDEPEND}"
