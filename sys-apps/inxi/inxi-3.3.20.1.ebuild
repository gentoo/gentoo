# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV=$(ver_rs 3 '-')
# 2.3.56 was the last version with no tagged release.
# It was also the last Bash based release. Later versions are Perl based

DESCRIPTION="The CLI inxi collects and prints hardware and system information"
HOMEPAGE="https://github.com/smxi/inxi"
SRC_URI="https://github.com/smxi/${PN}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${MY_PV}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ia64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="bluetooth hddtemp opengl"

RDEPEND="dev-lang/perl
	sys-apps/pciutils
	sys-apps/usbutils
	bluetooth? ( net-wireless/bluez )
	hddtemp? ( app-admin/hddtemp )
	opengl? ( x11-apps/mesa-progs )
	"

src_install() {
	dobin ${PN}
	doman ${PN}.1
	dodoc README.txt
}
