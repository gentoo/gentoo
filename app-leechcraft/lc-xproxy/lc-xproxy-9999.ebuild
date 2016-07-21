# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit leechcraft

DESCRIPTION="Provides advanced proxy support features for LeechCraft"

SLOT="0"
KEYWORDS=""
IUSE="debug"

DEPEND="~app-leechcraft/lc-core-${PV}"
RDEPEND="${DEPEND}"

pkg_postinst() {
	if ! has_version app-leechcraft/lc-qrosp || ! has_version dev-libs/qrosspython; then
		einfo "XProxy supports scriptable host lists to match, for example, against all sites in RosKomNadzor registry."
		einfo "Install app-lc/lc-qrosp and dev-libs/qrosspython to support these."
	fi
}
