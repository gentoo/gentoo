# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
#fails to build
#OASIS_BUILD_DOCS=1

inherit oasis

DESCRIPTION="OCaml module implementing 128 bits universally unique identifiers"
HOMEPAGE="http://erratique.ch/software/uuidm"
SRC_URI="http://erratique.ch/software/uuidm/releases/${P}.tbz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
