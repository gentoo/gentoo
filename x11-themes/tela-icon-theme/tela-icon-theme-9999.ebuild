# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

DESCRIPTION="A flat colorful Design icon theme"
HOMEPAGE="https://github.com/vinceliuice/Tela-icon-theme"
EGIT_REPO_URI="https://github.com/vinceliuice/${PN/tela/Tela}.git"
LICENSE="GPL-3+"
SLOT="0"
IUSE="+standard black blue brown green grey orange pink purple red yellow"
REQUIRED_USE="|| ( standard black blue brown green grey orange pink purple red yellow )"

BDEPEND="dev-util/gtk-update-icon-cache"

src_install() {
	local colorvariant=(
		$(usev standard)
		$(usev black)
		$(usev blue)
		$(usev brown)
		$(usev green)
		$(usev grey)
		$(usev orange)
		$(usev pink)
		$(usev purple)
		$(usev red)
		$(usev yellow)
	)

	einstalldocs

	dodir /usr/share/icons
	./install.sh -d "${D}/usr/share/icons" -c "${colorvariant[@]}" || die
}
