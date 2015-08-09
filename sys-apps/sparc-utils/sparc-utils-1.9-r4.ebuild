# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils toolchain-funcs

DESCRIPTION="Various sparc utilities from Debian GNU/Linux"
HOMEPAGE="http://packages.debian.org/sparc-utils"
SRC_URI="mirror://debian/pool/main/s/${PN}/${PN}_${PV}.orig.tar.gz
	mirror://debian/pool/main/s/${PN}/${PN}_${PV}-3.diff.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* sparc"
IUSE=""

DEPEND="virtual/os-headers"
RDEPEND="|| ( >=sys-apps/util-linux-2.13-r1 sys-apps/setarch )"

S=${WORKDIR}/${P}.orig

# NOTE: If a system has >=sys-kernel/linux-headers-2.6.0, don't build audioctl
#       as the SPARC sound drivers have been replaced by their ALSA equivalents

pkg_setup() {
	has_version '>=sys-kernel/linux-headers-2.6.0' && \
		einfo "Linux 2.6 kernel headers detected, not building audioctl"
}

src_unpack() {
	unpack ${A}
	epatch ${WORKDIR}/${PN}_${PV}-3.diff
	sed -i -e 's:#include <linux/elf.h>:#include <elf.h>:' \
	  ${S}/elftoaout*/elftoaout.c
}

src_compile() {
	emake -C elftoaout-2.3 CC="$(tc-getCC)" CFLAGS="${CFLAGS}" || die
	emake -C src piggyback piggyback64 CC="$(tc-getCC)" CFLAGS="${CFLAGS}" || die
	emake -C prtconf-1.3 CC="$(tc-getCC)" all || die
	has_version '>=sys-kernel/linux-headers-2.6.0'  || \
		emake -C audioctl-1.3 CC="$(tc-getCC)" || die
}

src_install() {
	# since the debian/piggyback64.1 manpage is a pointer to the
	# debian/piggyback.1 manpage, copy debian/piggyback.1 to
	# debian/piggyback64.1

	cp ${S}/debian/piggyback.1 ${S}/debian/piggyback64.1

	dobin elftoaout-2.3/elftoaout || die
	dobin src/piggyback || die
	dobin src/piggyback64 || die
	dosbin prtconf-1.3/prtconf || die
	dosbin prtconf-1.3/eeprom || die

	if ! has_version '>=sys-kernel/linux-headers-2.6.0'; then
		dobin audioctl-1.3/audioctl || die
		newinitd "${FILESDIR}"/audioctl.init audioctl || die
		newconfd debian/audioctl.def audioctl || die
		doman audioctl-1.3/audioctl.1
	fi

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
