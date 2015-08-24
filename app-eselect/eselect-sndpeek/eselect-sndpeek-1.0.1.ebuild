# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="Manages the /usr/bin/sndpeek symlink"
HOMEPAGE="https://www.gentoo.org/"
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
