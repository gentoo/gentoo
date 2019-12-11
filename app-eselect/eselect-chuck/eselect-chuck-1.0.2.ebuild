# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Manages the /usr/bin/chuck symlink"
HOMEPAGE="https://www.gentoo.org/"
SRC_URI="mirror://gentoo/chuck.eselect-${PVR}.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=app-admin/eselect-1.2.3"
DEPEND="!<=media-sound/chuck-1.2.1.2"

S=${WORKDIR}

src_install() {
	insinto /usr/share/eselect/modules
	newins "${WORKDIR}/chuck.eselect-${PVR}" chuck.eselect
}
