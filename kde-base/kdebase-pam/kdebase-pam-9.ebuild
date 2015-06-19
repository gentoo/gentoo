# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdebase-pam/kdebase-pam-9.ebuild,v 1.6 2015/03/03 07:58:11 dlan Exp $

EAPI=5

inherit pam

DESCRIPTION="pam.d files used by several KDE components"
HOMEPAGE="http://www.kde.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ppc ppc64 x86 ~x86-fbsd"
IUSE=""

DEPEND="virtual/pam"
RDEPEND="${DEPEND}"

S=${WORKDIR}

src_install() {
	newpamd "${FILESDIR}/kde.pam-${PV}" kde
	newpamd "${FILESDIR}/kde-np.pam-${PV}" kde-np
}
