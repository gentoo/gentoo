# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils leechcraft

DESCRIPTION="Quark handling text and images droppend onto it"

SLOT="0"
KEYWORDS=""
IUSE="debug"

DEPEND="~app-leechcraft/lc-core-${PV}
	dev-qt/qtdeclarative:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
"
RDEPEND="${DEPEND}
	~virtual/leechcraft-quark-sideprovider-${PV}
"

pkg_postinst() {
	elog "Install at least some of the following additional LeechCraft modules for Ooronee to be useful:"
	optfeature "upload images to imagebins" app-leechcraft/lc-imgaste
	optfeature "upload images to cloud hostings like Picasa or VKontante" app-leechcraft/lc-blasq
	optfeature "search text via OpenSearch" app-leechcraft/lc-seekthru
	optfeature "search text via Google" app-leechcraft/lc-pogooglue
}
