# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="WoeUSB  creates a Windows USB stick installer from a real Windows DVD or image."
HOMEPAGE="https://github.com/slacka/WoeUSB"
MY_PN="WoeUSB"
MY_P="${MY_PN}-${PV}"

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/slacka/${MY_PN}.git"

else
	SRC_URI="https://github.com/slacka/${MY_PN}/archive/v${PV}.tar.gz"
	S="${WORKDIR}/${MY_P}"
fi

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
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

src_install() {
	sed -i -e 's/@@WOEUSB_VERSION@@/3.1.4/g' src/woeusb
	dosbin src/woeusb
}
