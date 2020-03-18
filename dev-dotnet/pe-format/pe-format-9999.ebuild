# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools git-r3 systemd xdg-utils

DESCRIPTION="Intelligent PE executable wrapper for binfmt_misc"
HOMEPAGE="https://github.com/mgorny/pe-format2/"
EGIT_REPO_URI="https://github.com/mgorny/pe-format2.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="dev-util/desktop-file-utils"

src_prepare() {
	default
	eautoreconf
}

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
