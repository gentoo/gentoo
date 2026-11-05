# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

DESCRIPTION="UZDoom modification for realistic movement, physics, weapons and monster attacks"
HOMEPAGE="https://codeberg.org/mc776/HideousDestructor"
SRC_URI="https://codeberg.org/mc776/HideousDestructor/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}"

LICENSE="BSD GPL-3"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	games-engines/uzdoom
	|| (
		games-fps/freedoom-data
		games-fps/doom2-data-gog
		games-fps/doom-data-gog
	)
"

src_install() {
	dodoc *.md hd.txt
	rm *.md hd.txt licence.txt || die

	insinto /usr/share/${PN}
	doins -r *

	newbin - ${PN} <<-EOF
		#!/bin/sh
		exec uzdoom -file "${EPREFIX}/usr/share/${PN}" "\${@}"
	EOF
}

pkg_postinst() {
	elog "Hideous Destructor has many add-ons, notably the HD Bootcamp map."
}
