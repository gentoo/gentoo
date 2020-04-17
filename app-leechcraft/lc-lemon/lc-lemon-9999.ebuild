# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit leechcraft

DESCRIPTION="Network monitor plugin for LeechCraft"

SLOT="0"
KEYWORDS=""
IUSE="debug"

DEPEND="~app-leechcraft/lc-core-${PV}
	dev-libs/libnl:3
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	x11-libs/qwt:6
	"
RDEPEND="${DEPEND}
	~virtual/leechcraft-quark-sideprovider-${PV}"

pkg_postinst() {
	if has_version 'dev-qt/qtnetwork:5[-connman,-networkmanager]'; then
		ewarn "dev-qt/qtnetwork:5 was built without any bearer plugins, so detecting network"
		ewarn "devices may be crippled. Consider enabling either 'connman' or 'networkmanager'"
		ewarn "USE flags if that is a problem for you."
	fi
}
