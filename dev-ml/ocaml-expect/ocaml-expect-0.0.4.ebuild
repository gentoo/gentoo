# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ml/ocaml-expect/ocaml-expect-0.0.4.ebuild,v 1.1 2013/12/11 19:29:07 aballier Exp $

EAPI=5

OASIS_BUILD_DOCS=1
OASIS_BUILD_TESTS=1

inherit oasis

DESCRIPTION="Ocaml implementation of expect to help building unitary testing"
HOMEPAGE="http://forge.ocamlcore.org/projects/ocaml-expect/"
SRC_URI="http://forge.ocamlcore.org/frs/download.php/1289/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="test"

RDEPEND="
	dev-ml/batteries:=
	dev-ml/pcre-ocaml:="
DEPEND="${RDEPEND}
	test? ( >=dev-ml/ounit-2.0.0 )"

DOCS=( "README.txt" "CHANGES.txt" "AUTHORS.txt" )
