# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Firmware Test Suite"
HOMEPAGE="https://wiki.ubuntu.com/Kernel/Reference/fwts https://kernel.ubuntu.com/git/hwe/fwts.git"
SRC_URI="https://launchpad.net/ubuntu/+archive/primary/+files/${PN}_${PV}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="dev-libs/glib:2
	>=dev-libs/json-c-0.10-r1
	dev-libs/libbsd
	dev-libs/libpcre
	sys-apps/dmidecode
	sys-apps/dtc
	sys-apps/pciutils
	sys-power/iasl
	sys-power/pmtools
"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

S=${WORKDIR}

PATCHES=(
	"${FILESDIR}/${P}-slibtool.patch" # 780372
	"${FILESDIR}/${P}-werror.patch"
)

src_prepare() {
	default

	sed -e 's:/usr/bin/lspci:'$(type -p lspci)':' \
		-e 's:/usr/sbin/dmidecode:'$(type -p dmidecode)':' \
		-e 's:/usr/bin/iasl:'$(type -p iasl)':' \
		-i src/lib/include/fwts_binpaths.h || die

	eautoreconf
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die
}
