# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit autotools udev

DESCRIPTION="Library implementation for listing Vital Product Data"
HOMEPAGE="https://github.com/power-ras/libvpd"
SRC_URI="https://github.com/power-ras/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0/3"
KEYWORDS="~ppc ~ppc64"

DEPEND="
	dev-db/sqlite:3
	sys-libs/zlib:=
"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# sysconfdir is used only to establish where the udev rules file should go
	# unfortunately it also adds the subdirs on its own so we strip it down to
	# dirname
	local myconf=(
		--disable-static
		--localstatedir="${EPREFIX}/var"
		--sysconfdir="$( dirname $(get_udevdir) )"
	)

	econf "${myconf[@]}"
}

src_install() {
	default
	keepdir /var/lib/lsvpd
	find "${D}" -name '*.la' -delete || die
}
