# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdepim-icons/kdepim-icons-4.4.2015.06.ebuild,v 1.1 2015/07/12 22:04:59 dilfridge Exp $

EAPI=5

KMNAME="kdepim"
KMMODULE="icons"
inherit kde4-meta

DESCRIPTION="KDE PIM icons (noakonadi branch)"
IUSE=""
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"

src_install() {
	kde4-meta_src_install
	# colliding with oxygen icons
	rm -rf "${ED}"/${KDEDIR}/share/icons/oxygen/16x16/status/meeting-organizer.png
}
