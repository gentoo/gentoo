# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

DESCRIPTION="Folding over record fields"
HOMEPAGE="https://github.com/janestreet/fieldslib"
SRC_URI="https://github.com/janestreet/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="amd64 arm ~arm64 ppc ppc64 x86"
IUSE="+ocamlopt"

RDEPEND="
	>=dev-ml/base-0.14.0:=
	dev-ml/findlib:=
"
DEPEND="${RDEPEND}"
