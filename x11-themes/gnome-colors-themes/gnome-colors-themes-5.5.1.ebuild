# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit gnome2-utils

DESCRIPTION="Some gnome-colors iconsets including a Gentoo one"
HOMEPAGE="https://code.google.com/p/gnome-colors/"
SRC_URI="https://gnome-colors.googlecode.com/files/gnome-colors-${PV}.tar.gz
	https://dev.gentoo.org/~pacho/gnome-gentoo-${PV}.tar.gz"
S="${WORKDIR}"

LICENSE="GPL-2 public-domain"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="x11-themes/gnome-colors-common"

RESTRICT="binchecks strip"

src_install() {
	insinto /usr/share/icons

	local i
	for i in gnome*; do
		if [[ "${i}" != "gnome-colors-common" ]]; then
			doins -r "${i}"
		fi
	done

	einstalldocs
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
