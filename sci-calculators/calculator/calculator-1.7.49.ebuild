# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-calculators/calculator/calculator-1.7.49.ebuild,v 1.3 2015/06/11 14:16:36 ago Exp $

EAPI="5"

inherit fox

DESCRIPTION="Scientific calculator based on the FOX Toolkit"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ppc ~ppc64 ~sparc x86"
IUSE=""

RDEPEND="~x11-libs/fox-${PV}
	x11-libs/libICE
	x11-libs/libSM"
DEPEND="${RDEPEND}"
