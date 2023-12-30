# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Firmware Test Suite"
HOMEPAGE="https://wiki.ubuntu.com/Kernel/Reference/fwts https://github.com/fwts/fwts"
SRC_URI="https://github.com/fwts/fwts/archive/refs/tags/V${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
#https://github.com/fwts/fwts/issues/13
#KEYWORDS="~amd64"

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

PATCHES=(
	"${FILESDIR}/${PN}-22.03.00-werror.patch"
)

src_prepare() {
	default

	sed -e 's:/usr/bin/lspci:'$(type -p lspci)':' \
		-e 's:/usr/sbin/dmidecode:'$(type -p dmidecode)':' \
		-e 's:/usr/bin/iasl:'$(type -p iasl)':' \
		-i src/lib/include/fwts_binpaths.h || die

	eautoreconf
}

src_compile() {
	# https://github.com/fwts/fwts/issues/7
	emake -j1 --shuffle=none
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die
}
