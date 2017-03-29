# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

DESCRIPTION="Virtual for the gnat compiler selection"
SLOT="3.4"
KEYWORDS="~amd64 ~x86"
RDEPEND="|| (
	=dev-lang/gnat-gcc-${PV}*
	=dev-lang/gnat-gpl-${PV}* )"
