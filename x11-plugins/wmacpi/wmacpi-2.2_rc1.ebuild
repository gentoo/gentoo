# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils toolchain-funcs

DESCRIPTION="WMaker DockApp: ACPI status monitor for laptops"
HOMEPAGE="http://himi.org/wmacpi/"
MY_PV="${PV/_}"
MY_P="${PN}-${MY_PV}"
S="${WORKDIR}/${MY_P}"
SRC_URI="http://himi.org/wmacpi/download/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 -ppc -sparc x86"
IUSE=""

DEPEND="<x11-libs/libdockapp-0.7
	x11-libs/libX11"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	# acpi and acpi.1 conflict with sys-power/acpi - Bug #60685
	mv acpi.c acpi-batt-status.c
	mv acpi.1 acpi-batt-status.1
	epatch "${FILESDIR}"/${P}-makefile.patch
}

src_compile() {
	emake CC="$(tc-getCC)" OPT="${CFLAGS}" || die "compile failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	dodoc AUTHORS ChangeLog README TODO
}

pkg_postinst() {
	elog "The command-line utility are corresponding manpage are installed"
	elog "as acpi-batt-status to prevent collisions with sys-power/acpi"
}
