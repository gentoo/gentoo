# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

OASIS_BUILD_DOCS=1
OASIS_BUILD_TESTS=1

inherit oasis

DESCRIPTION="Ocaml implementation of expect to help building unitary testing"
HOMEPAGE="http://forge.ocamlcore.org/projects/ocaml-expect/"
SRC_URI="http://forge.ocamlcore.org/frs/download.php/1372/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	dev-ml/batteries:=
	dev-ml/pcre-ocaml:="
DEPEND="${RDEPEND}
	test? ( >=dev-ml/ounit-2.0.0 )"

DOCS=( "README.txt" "CHANGES.txt" "AUTHORS.txt" )
