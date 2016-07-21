# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3

inherit eutils

DESCRIPTION="Manages the /usr/bin/miniAudicle symlink"
HOMEPAGE="https://www.gentoo.org/"
SRC_URI="mirror://gentoo/miniaudicle.eselect-${PV}.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=app-admin/eselect-1.2.3"

src_prepare() {
	# Fixes listing as described in bug 320189, not upstream yet
	epatch "${FILESDIR}"/miniaudicle-1.0.1_list.patch
}

src_install() {
	insinto /usr/share/eselect/modules
	newins "${WORKDIR}/miniaudicle.eselect-${PV}" miniaudicle.eselect || die
}
