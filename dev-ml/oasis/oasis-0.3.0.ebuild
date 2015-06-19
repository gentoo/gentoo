# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ml/oasis/oasis-0.3.0.ebuild,v 1.4 2013/03/03 11:18:08 aballier Exp $

EAPI=5

OASIS_BUILD_TESTS=1
OASIS_BUILD_DOCS=1

inherit oasis

MY_P=${P/_/\~}
DESCRIPTION="OASIS is a tool to integrate a configure, build and install system in OCaml project"
HOMEPAGE="http://oasis.forge.ocamlcore.org/index.php"
SRC_URI="http://forge.ocamlcore.org/frs/download.php/918/${MY_P}.tar.gz"

LICENSE="LGPL-2.1-with-linking-exception"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=">=dev-ml/ocaml-data-notation-0.0.3:="
DEPEND="${RDEPEND}
	dev-ml/ocamlify
	dev-ml/ocamlmod
	!<sci-chemistry/oasis-4.0-r3
	test? (
		>=dev-ml/ocaml-fileutils-0.4.2
		>=dev-ml/ounit-1.1.0
		>=dev-ml/ocaml-expect-0.0.2
		dev-ml/extlib
	)"

STRIP_MASK="*/bin/*"
S="${WORKDIR}/${MY_P}"
DOCS=( "README.txt" "TODO.txt" "AUTHORS.txt" "CHANGES.txt" )
