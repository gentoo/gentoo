# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils

DESCRIPTION="WMaker DockApp: ACPI status monitor for laptops"
HOMEPAGE="http://www.ne.jp/asahi/linux/timecop/"
SRC_URI="http://www.ne.jp/asahi/linux/timecop/software/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc -sparc x86"
IUSE="acpi apm"

DEPEND="x11-libs/libdockapp"

src_unpack() {
	unpack ${A}
	cd "${S}"
	use apm && use acpi && eerror "APM and ACPI are in USE ... defaulting to ACPI"
	use apm || use acpi || eerror "Neither APM or ACPI are in USE ... defaulting to ACPI"
	if use acpi || ! use apm ; then
		epatch "${FILESDIR}"/${PV}-acpi.patch
	else
		epatch "${FILESDIR}"/${PV}-apm.patch
	fi
}

src_compile() {
	emake OPT="${CFLAGS}" || die "emake failed."
}

src_install() {
	dobin wmacpi || die "dobin failed."
	dodoc AUTHORS ChangeLog README
}
