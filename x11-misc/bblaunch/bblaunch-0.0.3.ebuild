# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="An application launcher for Blackbox type window managers"
HOMEPAGE="http://blackboxwm.sourceforge.net/"
SRC_URI="http://www.stud.ifi.uio.no/~steingrd/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="ppc x86"

PATCHES=( "${FILESDIR}/${P}.patch" )
