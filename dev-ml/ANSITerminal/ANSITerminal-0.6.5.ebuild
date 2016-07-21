# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

OASIS_BUILD_DOCS=1

inherit oasis eutils

DESCRIPTION="Module which offers basic control of ANSI compliant terminals"
HOMEPAGE="http://forge.ocamlcore.org/projects/ansiterminal/"
SRC_URI="http://forge.ocamlcore.org/frs/download.php/1206/${P}.tar.gz"
LICENSE="LGPL-3-with-linking-exception"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
DEPEND=""
RDEPEND="${DEPEND}"
IUSE=""

DOCS=( "README.txt" "AUTHORS.txt" )
