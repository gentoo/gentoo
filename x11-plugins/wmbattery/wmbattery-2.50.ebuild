# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools

DESCRIPTION="A dockable app to report APM, ACPI, or SPIC battery status"
HOMEPAGE="http://windowmaker.org/dockapps/?name=wmbattery"
# Grab from http://windowmaker.org/dockapps/?download=${P}.tar.gz
SRC_URI="https://dev.gentoo.org/~voyageur/distfiles/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc -sparc ~x86"
IUSE="apm +upower"

RDEPEND="apm? ( sys-apps/apmd )
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm
	upower? ( || ( >=sys-power/upower-0.9.23 sys-power/upower-pm-utils ) )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( ChangeLog README TODO )

src_prepare() {
	sed -i \
		-e '/^icondir/s:icons:pixmaps:' \
		autoconf/makeinfo.in || die

	use upower || { sed -i -e 's:USE_UPOWER = 1:#&:' autoconf/makeinfo.in || die; }

	eautoreconf
}
