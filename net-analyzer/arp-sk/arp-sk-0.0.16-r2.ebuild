# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="A swiss knife tool for ARP"
HOMEPAGE="http://sid.rstack.org/arp-sk/"
SRC_URI="http://sid.rstack.org/arp-sk/files/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ~riscv x86"

DEPEND=">=net-libs/libnet-1.1"
RDEPEND="${DEPEND}"

DOCS=( ARP AUTHORS CONTRIB ChangeLog README TODO )

PATCHES=(
	"${FILESDIR}"/${P}-libnet1_2.patch
)

src_prepare() {
	default
	sed -i configure.in -e 's|AM_CONFIG_HEADER|AC_CONFIG_HEADERS|g' || die
	rm missing || die

	eautoreconf
}

src_install() {
	default

	# We don't need libcompat as it has a potential to clash with other packages.
	rm -r "${ED}"/usr/$(get_libdir) || die
}
