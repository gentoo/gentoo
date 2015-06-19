# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-eselect/eselect-sndpeek/eselect-sndpeek-1.0.1.ebuild,v 1.1 2015/03/31 16:56:46 ulm Exp $

DESCRIPTION="Manages the /usr/bin/sndpeek symlink"
HOMEPAGE="http://www.gentoo.org/"
SRC_URI="mirror://gentoo/sndpeek.eselect-${PVR}.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=app-admin/eselect-1.2.3"

src_install() {
	insinto /usr/share/eselect/modules
	newins "${WORKDIR}/sndpeek.eselect-${PVR}" sndpeek.eselect || die
}
