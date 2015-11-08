# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit kde4-base

DESCRIPTION="A library for image plugins accross KDE applications"
KEYWORDS="~amd64 ~x86"
IUSE="debug minimal"

src_install() {
	kde4-base_src_install

	if use minimal ; then
		rm -r "${D}"/usr/share/icons
	fi
}
