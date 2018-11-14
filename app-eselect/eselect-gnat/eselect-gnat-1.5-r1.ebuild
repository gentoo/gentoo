# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils

DESCRIPTION="gnat module for eselect"
HOMEPAGE="https://www.gentoo.org"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86 ~sparc"

IUSE=""
RDEPEND=">=app-admin/eselect-1.2.5"

S="${WORKDIR}"

MODULEDIR="/usr/share/eselect/modules"

# NOTE!!
# This path is duplicated in gnat-eselect module,
# adjust in both locations!
LIBDIR="/usr/share/gnat/lib"

src_install() {
	dodir ${MODULEDIR}
	insinto ${MODULEDIR}
	newins "${FILESDIR}"/gnat.eselect-${PV} gnat.eselect
	dodir ${LIBDIR}
	insinto ${LIBDIR}
	# !ATTN!
	# Make sure to adjust version of installed file to a proper one if there is
	# a change!
	newins "${FILESDIR}"/gnat-common-${PV}.bash gnat-common.bash
}
