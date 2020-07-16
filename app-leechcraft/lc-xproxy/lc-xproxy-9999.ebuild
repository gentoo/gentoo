# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit leechcraft

DESCRIPTION="Provides advanced proxy support features for LeechCraft"

SLOT="0"
KEYWORDS=""
IUSE="debug"

DEPEND="~app-leechcraft/lc-core-${PV}
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
"
RDEPEND="${DEPEND}"

pkg_postinst() {
	if ! has_version app-leechcraft/lc-qrosp || ! has_version dev-libs/qrosspython; then
		einfo "XProxy supports scriptable host lists to match, for example, against all sites in RosKomNadzor registry."
		einfo "Install app-lc/lc-qrosp and dev-libs/qrosspython to support these."
	fi
}
