# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd xdg-utils

DESCRIPTION="Intelligent PE executable wrapper for binfmt_misc"
HOMEPAGE="https://github.com/projg2/pe-format2/"
SRC_URI="
	https://github.com/projg2/pe-format2/releases/download/v${PV}/${P}.tar.bz2
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"

src_configure() {
	local myconf=(
		--with-systemdsystemunitdir="$(systemd_get_systemunitdir)"
	)
	econf "${myconf[@]}"
}

src_install() {
	default
	keepdir /var/lib
}

pkg_postinst() {
	ebegin "Calling pe-format2-setup to update handler setup"
	pe-format2-setup
	eend ${?}

	xdg_desktop_database_update
}
