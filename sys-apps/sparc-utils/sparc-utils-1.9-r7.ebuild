# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Various sparc utilities from Debian GNU/Linux"
HOMEPAGE="https://packages.debian.org/sparc-utils"
SRC_URI="mirror://debian/pool/main/s/${PN}/${PN}_${PV}.orig.tar.gz
	mirror://debian/pool/main/s/${PN}/${PN}_${PV}-4.diff.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* sparc"
IUSE=""

DEPEND="virtual/os-headers"
RDEPEND=">=sys-apps/util-linux-2.13-r1"

S=${WORKDIR}/${P}.orig

PATCHES=(
	"${WORKDIR}/${PN}_${PV}-4.diff"
	"${FILESDIR}"/${P}-no-implicit.patch
	"${FILESDIR}"/elftoaout-2.3-64bit_fixes-1.patch
)

src_compile() {
	emake -C elftoaout-2.3 \
		CC="$(tc-getCC)" CFLAGS="${CFLAGS}"
	emake -C src piggyback piggyback64 \
		CC="$(tc-getCC)" CFLAGS="${CFLAGS}"
	emake -C prtconf-1.3 all \
		CC="$(tc-getCC)"
}

src_install() {
	# since the debian/piggyback64.1 manpage is a pointer to the
	# debian/piggyback.1 manpage, copy debian/piggyback.1 to
	# debian/piggyback64.1

	cp "${S}"/debian/piggyback.1 "${S}"/debian/piggyback64.1 || die

	dobin elftoaout-2.3/elftoaout
	dobin src/piggyback
	dobin src/piggyback64
	dosbin prtconf-1.3/prtconf
	dosbin prtconf-1.3/eeprom

	doman elftoaout-2.3/elftoaout.1
	doman prtconf-1.3/prtconf.8
	doman prtconf-1.3/eeprom.8
	doman debian/piggyback.1
	doman debian/piggyback64.1
}

pkg_postinst() {
	ewarn "In order to have /usr/sbin/eeprom, make sure you build /dev/openprom"
	ewarn "device support (CONFIG_SUN_OPENPROMIO) into the kernel, or as a"
	ewarn "module (and that the module is loaded)."
}
