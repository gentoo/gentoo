# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/adjustableclock/adjustableclock-4.1.4.ebuild,v 1.4 2014/11/03 09:40:32 ago Exp $

EAPI=5

KDE_LINGUAS_DIR="applet/locale"
KDE_LINGUAS="de et pl pt pt_BR sv tr uk"
inherit kde4-base

DESCRIPTION="Plasmoid to show date and time in adjustable format using rich text"
HOMEPAGE="http://kde-look.org/content/show.php/Adjustable+Clock?content=92825"
SRC_URI="http://kde-look.org/CONTENT/content-files/92825-${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="amd64 x86"
IUSE="debug"

DEPEND="
	$(add_kdebase_dep libplasmaclock)
"
RDEPEND="${DEPEND}
	$(add_kdebase_dep plasma-workspace)
"

src_prepare() {
	kde4-base_src_prepare

	local lang
	for lang in ${KDE_LINGUAS} ; do
		if ! use linguas_${lang} ; then
			rm ${KDE_LINGUAS_DIR}/${lang}.mo
		fi
	done
}

pkg_postinst() {
	elog "Version 4.0 (and newer) is not backwards compatible with 3.x."
	elog "All custom formats need to be exported and manually converted."
}
