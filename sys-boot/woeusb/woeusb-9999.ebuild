# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="WoeUSB creates a bootable installation USB drive from a Microsoft ISO file."
HOMEPAGE="https://github.com/slacka/WoeUSB"
MY_PN="WoeUSB"
MY_P="${MY_PN}-${PV}"

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/slacka/${MY_PN}.git"
	KEYWORDS=""
else
	SRC_URI="https://github.com/slacka/${MY_PN}/archive/v${PV}.tar.gz"
	KEYWORDS=""
	S="${WORKDIR}/${MY_P}"
fi

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	sys-apps/coreutils
	sys-apps/grep
	sys-apps/util-linux
	sys-block/parted
	sys-boot/grub:2
	sys-fs/ntfs3g"

src_install() {
	dosbin src/woeusb
}
