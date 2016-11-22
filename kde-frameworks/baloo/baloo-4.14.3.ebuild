# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit kde4-base

DESCRIPTION="Framework for searching and managing metadata"
KEYWORDS="amd64 ~arm x86 ~amd64-linux ~x86-linux"
IUSE="debug minimal"

DEPEND="
	$(add_kdeapps_dep kdepimlibs)
	dev-libs/qjson
	=dev-libs/xapian-1.2*[chert]
	kde-frameworks/kfilemetadata:4
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
