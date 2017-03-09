# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

OASIS_BUILD_DOCS=1

inherit oasis

DESCRIPTION="Unsigned ints for OCaml"
HOMEPAGE="https://forge.ocamlcore.org/projects/ocaml-uint/"
SRC_URI="https://forge.ocamlcore.org/frs/download.php/1516/${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
