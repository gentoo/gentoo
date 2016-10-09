# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# Bridge the old SLOT=5[/6] ebuild to the new SLOT=0/6 since the slotmove
# functionality does not handle implicit subslots correctly. #558856

EAPI="5"

inherit multilib-build

DESCRIPTION="transitional package"
HOMEPAGE="https://www.gnu.org/software/ncurses/ http://dickey.his.com/ncurses/"

LICENSE="metapackage"
SLOT="5/6"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 hppa ~ia64 ~m68k ~mips ~ppc ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd"
IUSE="ada +cxx gpm static-libs tinfo unicode"

DEPEND="sys-libs/ncurses:0/6[ada?,cxx?,gpm?,static-libs?,tinfo?,unicode?,${MULTILIB_USEDEP}]"
RDEPEND="${DEPEND}"
