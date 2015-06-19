# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/xxv-skins/xxv-skins-1.6.1.ebuild,v 1.1 2014/05/18 10:27:01 hd_brummy Exp $

EAPI=5

inherit eutils

DESCRIPTION="Additional skins for XXV"
HOMEPAGE="http://projects.vdr-developer.org/projects/xxv"
SRC_URI="mirror://vdr-developerorg/719/${P}.tgz
		mirror://vdr-developerorg/720/xxv-jason-${PV}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND="=www-misc/xxv-${PV}"

SKINROOT=/usr/share/xxv/skins

src_compile() {
:
}

src_install() {

	insinto ${SKINROOT}

	cd "${S}"
	cp -a * "${D}${SKINROOT}"

	cd "${WORKDIR}"
	cp -a jason "${D}${SKINROOT}"
}
