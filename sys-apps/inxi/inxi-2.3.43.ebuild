# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_COMMIT="0e7227d25cbf9e83f7fc6af5e1bcb919855f9ecf"
# ^^ because upstream refuses to tag commits with version numbers

DESCRIPTION="The CLI inxi collects and prints hardware and system information"
HOMEPAGE="https://github.com/smxi/inxi"
SRC_URI="https://github.com/smxi/${PN}/tarball/${MY_COMMIT} -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"
IUSE="bluetooth hddtemp opengl"

DEPEND=""
RDEPEND="sys-apps/pciutils
	sys-apps/usbutils
	bluetooth? ( net-wireless/bluez )
	hddtemp? ( app-admin/hddtemp )
	opengl? ( x11-apps/mesa-progs )
	"

S="${WORKDIR}/smxi-${PN}-${MY_COMMIT:0:7}"

src_install() {
	dobin ${PN}
	unpack ./${PN}.1.gz
	doman ${PN}.1
}
