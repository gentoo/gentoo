# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools

DESCRIPTION="A dockable app to report APM, ACPI, or SPIC battery status"
HOMEPAGE="http://joeyh.name/code/wmbattery/"
SRC_URI="mirror://debian/pool/main/w/${PN}/${PN}_${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc -sparc x86"
IUSE="upower"

RDEPEND="sys-apps/apmd
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm
	upower? ( || ( >=sys-power/upower-0.9.23 sys-power/upower-pm-utils ) )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( README TODO debian/changelog )

src_prepare() {
	sed -i \
		-e '/^icondir/s:icons:pixmaps:' \
		autoconf/makeinfo.in || die

	use upower || { sed -i -e 's:USE_UPOWER = 1:#&:' autoconf/makeinfo.in || die; }

	eautoconf
}
