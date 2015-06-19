# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-apps/kdeadmin-meta/kdeadmin-meta-4.14.3.ebuild,v 1.1 2015/06/04 18:44:39 kensington Exp $

EAPI=5
inherit kde4-meta-pkg

DESCRIPTION="KDE administration tools - merge this to pull in all kdeadmin-derived packages"
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	$(add_kdeapps_dep kcron)
	$(add_kdeapps_dep ksystemlog)
	$(add_kdeapps_dep kuser)
"
