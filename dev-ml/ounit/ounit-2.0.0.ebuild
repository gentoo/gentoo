# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

OASIS_BUILD_DOCS=1

inherit oasis

DESCRIPTION="Unit testing framework for OCaml"
HOMEPAGE="http://ounit.forge.ocamlcore.org/"
SRC_URI="http://forge.ocamlcore.org/frs/download.php/1258/${P}.tar.gz"
LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="amd64 arm ~arm64 ~ppc x86"
DEPEND=""
RDEPEND="${DEPEND}"
IUSE=""

DOCS=( "README.txt" "AUTHORS.txt" "changelog" )
