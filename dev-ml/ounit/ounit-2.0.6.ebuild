# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

OASIS_BUILD_DOCS=1

inherit oasis

DESCRIPTION="Unit testing framework for OCaml"
HOMEPAGE="http://ounit.forge.ocamlcore.org/"
SRC_URI="https://forge.ocamlcore.org/frs/download.php/1722/${P}.tar.gz"
LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="amd64 arm ~arm64 ~ppc ~ppc64 x86"
DEPEND=""
RDEPEND="${DEPEND}"
IUSE=""

DOCS=( "README.txt" "AUTHORS.txt" "changelog" )
