# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ml/batteries/batteries-2.3.ebuild,v 1.1 2014/12/01 08:59:34 aballier Exp $

EAPI=5

inherit oasis

DESCRIPTION="The community-maintained foundation library for your OCaml projects"
HOMEPAGE="http://batteries.forge.ocamlcore.org/"
SRC_URI="https://forge.ocamlcore.org/frs/download.php/1465/${P}.tar.gz"

LICENSE="LGPL-2.1-with-linking-exception"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="test"

RDEPEND="dev-ml/camomile:="
DEPEND="${RDEPEND}
	test? ( dev-ml/ounit dev-ml/iTeML )"

DOCS=( "ChangeLog" "FAQ" "README.folders" "README.md" )
