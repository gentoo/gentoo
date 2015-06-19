# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/kgrubeditor/kgrubeditor-0.8.5.ebuild,v 1.5 2014/03/20 22:11:08 johu Exp $

EAPI=5

inherit kde4-base

MY_PN="KGRUBEditor"

DESCRIPTION="A KDE utility that edits GRUB configuration files"
HOMEPAGE="http://www.kde-apps.org/content/show.php?content=75442"
SRC_URI="mirror://sourceforge/${PN}/${MY_PN}-${PV}-src.tar.bz2"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND="|| ( <sys-boot/grub-1
	sys-boot/grub-static )"

pkg_postinst() {
	ewarn
	ewarn "NOTE: kgrubeditor can not handle grub-2.x configuration files!"
	ewarn
}
