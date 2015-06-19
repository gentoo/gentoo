# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/baloo/baloo-4.14.3.ebuild,v 1.5 2015/02/17 11:06:38 ago Exp $

EAPI=5

inherit kde4-base

DESCRIPTION="Next generation of the Nepomuk project"
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="debug minimal"

DEPEND="
	$(add_kdebase_dep kdepimlibs)
	$(add_kdebase_dep kfilemetadata)
	dev-libs/qjson
	=dev-libs/xapian-1.2*[chert]
	sys-apps/attr
	!<kde-base/nepomuk-4.12.50
"
RDEPEND="
	${DEPEND}
"
RESTRICT="test"

src_install() {
	kde4-base_src_install

	if use minimal ; then
		rm "${D}"/usr/bin/baloo*
		rm -r "${D}"/usr/share/dbus-1
		rm -r "${D}"/usr/share/icons
		rm -r "${D}"/usr/share/polkit-1
	fi
}
