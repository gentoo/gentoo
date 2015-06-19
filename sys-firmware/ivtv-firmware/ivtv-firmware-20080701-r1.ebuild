# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-firmware/ivtv-firmware/ivtv-firmware-20080701-r1.ebuild,v 1.2 2013/03/16 13:29:37 ssuominen Exp $

EAPI=5

DESCRIPTION="firmware for Hauppauge PVR-x50 and Conexant 2341x based cards"
HOMEPAGE="http://www.ivtvdriver.org/index.php/Firmware"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="Hauppauge-Firmware"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

S=${WORKDIR}

src_install() {
	insinto /lib/firmware
	doins v4l-cx2341x-*.fw v4l-pvrusb2-*.fw
	doins *.mpg
}
