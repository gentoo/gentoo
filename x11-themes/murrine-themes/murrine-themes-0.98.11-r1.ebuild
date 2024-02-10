# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg-utils

DESCRIPTION="Themes for the Murrine GTK+2 Cairo Engine"
HOMEPAGE="https://tracker.debian.org/pkg/murrine-themes"
SRC_URI="mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_${PV}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~loong ppc ppc64 ~riscv x86"

RDEPEND=">=x11-themes/gtk-engines-murrine-0.98.0"

S="${WORKDIR}"/${PN}

src_prepare() {
	default

	# Depends on unpackaged theme Bluebird
	rm -r usr/share/themes/shearwater || die
}

src_install() {
	insinto /usr/share/icons
	doins -r usr/share/icons/*

	insinto /usr/share/themes
	doins -r usr/share/themes/*
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
