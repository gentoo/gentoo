# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-eselect/eselect-miniaudicle/eselect-miniaudicle-1.0.1-r1.ebuild,v 1.1 2015/03/31 16:51:29 ulm Exp $

EAPI=3

inherit eutils

DESCRIPTION="Manages the /usr/bin/miniAudicle symlink"
HOMEPAGE="http://www.gentoo.org/"
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
