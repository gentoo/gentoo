# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools

DESCRIPTION="A dockable app to report APM, ACPI, or SPIC battery status"
HOMEPAGE="https://www.dockapps.net/wmbattery"
SRC_URI="https://www.dockapps.net/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc -sparc ~x86"
IUSE="apm +upower"

RDEPEND="apm? ( sys-apps/apmd )
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm
	upower? ( >=sys-power/upower-0.9.23 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( ChangeLog README TODO )

src_prepare() {
	default

	sed -i \
		-e '/^icondir/s:icons:pixmaps:' \
		autoconf/makeinfo.in || die

	use upower || { sed -i -e 's:USE_UPOWER = 1:#&:' autoconf/makeinfo.in || die; }

	eautoreconf
}
