# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/nss-usrfiles/nss-usrfiles-2.18.1.ebuild,v 1.2 2015/04/18 12:26:41 swegener Exp $

EAPI=5

MY_PN="nss-altfiles"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="NSS module to read passwd/group files from CoreOS /usr location"
HOMEPAGE="https://github.com/coreos/${MY_PN}"
SRC_URI="https://github.com/coreos/${MY_PN}/archive/v${PV}.zip -> ${MY_P}.zip"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64-linux"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
S="${WORKDIR}/${MY_P}"

src_configure() {
	: # Don't bother with the custom configure script.
}

src_compile() {
	emake DATADIR=/usr/share/baselayout MODULE_NAME=usrfiles
}

src_install() {
	dolib.so libnss_usrfiles.so.2
}
