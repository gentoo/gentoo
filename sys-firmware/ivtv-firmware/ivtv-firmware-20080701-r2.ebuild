# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="firmware for Hauppauge PVR-x50 and Conexant 2341x based cards"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="Hauppauge-Firmware"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

S=${WORKDIR}

src_install() {
	insinto /lib/firmware
	doins v4l-cx2341x-*.fw v4l-pvrusb2-*.fw
	doins *.mpg
}
