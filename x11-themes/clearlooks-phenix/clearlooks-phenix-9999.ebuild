# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/clearlooks-phenix/clearlooks-phenix-9999.ebuild,v 1.5 2014/10/29 13:47:42 hasufell Exp $

EAPI=5

inherit git-2

DESCRIPTION="Clearlooks-Phenix is a GTK+ 3 port of Clearlooks, the default theme for GNOME 2"
HOMEPAGE="http://www.jpfleury.net/en/software/clearlooks-phenix.php"
EGIT_REPO_URI="https://github.com/jpfleury/clearlooks-phenix.git"

KEYWORDS=""
LICENSE="GPL-3"
SLOT="live"
IUSE=""

RDEPEND="x11-libs/gtk+:3
	x11-themes/gtk-engines"

src_install() {
	insinto "/usr/share/themes/Clearlooks-Phenix-${SLOT}"
	doins -r *
}

pkg_postinst() {
	elog "The theme is named Clearlooks-Phenix-${SLOT}."
}
