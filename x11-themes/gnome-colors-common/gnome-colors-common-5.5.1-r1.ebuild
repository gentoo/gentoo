# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit gnome2-utils

DESCRIPTION="Colorized icons shared between all gnome-colors iconsets"
HOMEPAGE="https://code.google.com/p/gnome-colors/"
SRC_URI="https://gnome-colors.googlecode.com/files/gnome-colors-${PV}.tar.gz
	branding? ( https://www.mail-archive.com/tango-artists@lists.freedesktop.org/msg00043/tango-gentoo-v1.1.tar.gz )"
S="${WORKDIR}"

LICENSE="
	GPL-2
	branding? ( CC-BY-SA-4.0 )
"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+branding"

RDEPEND="x11-themes/adwaita-icon-theme"
RESTRICT="binchecks strip"

src_prepare() {
	default

	if use branding; then
		for i in 16 22 24 32 ; do
			cp tango-gentoo-v1.1/${i}x${i}/gentoo.png \
				gnome-colors-common/${i}x${i}/places/start-here.png \
			|| die "Copying gentoo logos failed"
		done

		cp tango-gentoo-v1.1/scalable/gentoo.svg \
			gnome-colors-common/scalable/places/start-here.svg \
		|| die "Copying scalable logo failed"
	fi
}

src_install() {
	insinto /usr/share/icons
	doins -r "${WORKDIR}/${PN}"

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
