# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="WoeUSB  creates a Windows USB stick installer from a real Windows DVD or image."
HOMEPAGE="https://github.com/slacka/WoeUSB"

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/slacka/${PN}.git"

else
	SRC_URI="https://github.com/slacka/${PN}/archive/v${PV}.tar.gz -> ${PN}-${PV}.tar.gz"
	S="${WORKDIR}/WoeUSB-${PV}"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE=""

DEPEND="sys-apps/sed"
RDEPEND="${DEPEND}
	sys-apps/coreutils
	sys-apps/grep
	sys-apps/util-linux
	sys-block/parted
	sys-boot/grub:2
	sys-fs/ntfs3g
	sys-fs/dosfstools"

src_prepare() {
	default
	sed -i "s/@@WOEUSB_VERSION@@/${PV}/g" "src/woeusb" "src/woeusb.1"
}
	
src_install() {
	dosbin src/woeusb
	doman src/woeusb.1
}
