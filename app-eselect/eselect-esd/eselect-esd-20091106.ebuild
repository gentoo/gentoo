# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-eselect/eselect-esd/eselect-esd-20091106.ebuild,v 1.1 2015/03/31 16:48:28 ulm Exp $

DESCRIPTION="Manages configuration of ESounD implementation or PulseAudio wrapper"
HOMEPAGE="http://www.gentoo.org/"
SRC_URI="mirror://gentoo/esd.eselect-${PVR}.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE=""

RDEPEND=">=app-admin/eselect-1.2.3
	!<media-sound/esound-0.2.36-r2"

src_install() {
	insinto /usr/share/eselect/modules
	newins "${WORKDIR}/esd.eselect-${PVR}" esd.eselect || die
}
