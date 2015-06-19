# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/cx_Freeze/cx_Freeze-4.3.1-r2.ebuild,v 1.5 2015/04/08 08:05:03 mgorny Exp $

EAPI="5"

PYTHON_COMPAT=( python{2_7,3_3} )
inherit distutils-r1

DESCRIPTION="Create standalone executables from Python scripts"
HOMEPAGE="http://cx-freeze.sourceforge.net"
SRC_URI="mirror://sourceforge/cx-freeze/${P}.tar.gz"

LICENSE="PYTHON"
SLOT="0"
KEYWORDS="amd64 x86"

DOCS=( README.txt )

PATCHES=(
	"${FILESDIR}/${PN}-4.3.2-buildsystem.patch" # bug #491602
)
