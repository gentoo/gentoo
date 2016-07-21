# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="The library implementing the Cangjie input method"
HOMEPAGE="http://cangjians.github.io"
SRC_URI="http://cangjians.github.io/downloads/libcangjie/libcangjie-${PV}.tar.xz"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-db/sqlite:3="

RDEPEND="${DEPEND}"
