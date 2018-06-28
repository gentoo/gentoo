# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=0

DESCRIPTION="Static GNU GRUB boot loader"

HOMEPAGE="https://www.gnu.org/software/grub/"
SRC_URI="mirror://gentoo/grub-static-${PV}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* amd64 ~x86"
IUSE=""
DEPEND="!<sys-boot/grub-2"
RDEPEND="${DEPEND}"

src_install() {
	cp -a "${WORKDIR}"/* "${D}"/
}
