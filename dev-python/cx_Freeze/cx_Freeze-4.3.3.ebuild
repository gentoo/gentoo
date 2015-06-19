# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/cx_Freeze/cx_Freeze-4.3.3.ebuild,v 1.2 2014/12/02 09:48:47 pacho Exp $

EAPI="5"

PYTHON_COMPAT=( python{2_7,3_3,3_4} )
inherit distutils-r1

DESCRIPTION="Create standalone executables from Python scripts"
HOMEPAGE="http://cx-freeze.sourceforge.net"
SRC_URI="mirror://sourceforge/cx-freeze/${P}.tar.gz"

LICENSE="PYTHON"
SLOT="0"
KEYWORDS="amd64 x86"

PATCHES=(
	"${FILESDIR}/${PN}-4.3.2-buildsystem.patch" # bug #491602
)
# test folder missing half the source content.
