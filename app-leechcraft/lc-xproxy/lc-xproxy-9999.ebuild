# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-leechcraft/lc-xproxy/lc-xproxy-9999.ebuild,v 1.2 2014/08/04 18:17:57 maksbotan Exp $

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
