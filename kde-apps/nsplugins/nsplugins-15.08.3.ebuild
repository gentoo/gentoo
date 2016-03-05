# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KMNAME="kde-baseapps"
inherit kde4-meta pax-utils

DESCRIPTION="Netscape plugins support for Konqueror"
KEYWORDS="amd64 ~x86"
IUSE="debug"

DEPEND="
	x11-libs/libXt
"
RDEPEND="${DEPEND}
	$(add_kdeapps_dep konqueror)
"

KMEXTRACTONLY="
	konqueror/settings/
"

src_install() {
	kde4-base_src_install

	# bug 419513
	pax-mark m "${ED}"usr/bin/nspluginviewer
}
