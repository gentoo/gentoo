# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils

DESCRIPTION="mpost module for eselect"
HOMEPAGE="https://www.gentoo.org/proj/en/eselect/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~ppc ~ppc64 s390 sh sparc x86 ~x86-fbsd"
IUSE=""

DEPEND=""
# Depend on texlive-core-2008 that allows usage of this module, otherwise it
# will not work so nicely.
RDEPEND=">=app-admin/eselect-1.2.3
	>=app-text/texlive-core-2008"

src_install() {
	local MODULEDIR="/usr/share/eselect/modules"
	local MODULE="mpost"
	dodir ${MODULEDIR}
	insinto ${MODULEDIR}
	newins "${FILESDIR}/${MODULE}.eselect-${PVR}" ${MODULE}.eselect \
		|| die "failed to install"
}
