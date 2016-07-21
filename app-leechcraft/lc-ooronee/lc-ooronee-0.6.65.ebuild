# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils leechcraft

DESCRIPTION="Quark handling text and images droppend onto it"

SLOT="0"
KEYWORDS=" ~amd64 ~x86"
IUSE="debug"

DEPEND="~app-leechcraft/lc-core-${PV}"
RDEPEND="${DEPEND}
	virtual/leechcraft-quark-sideprovider
"

pkg_postinst() {
	elog "Install at least some of the following additional LeechCraft modules for Ooronee to be useful:"
	optfeature "upload images" app-leechcraft/lc-imgaste app-leechcraft/lc-blasq
	optfeature "search via OpenSearch" app-leechcraft/lc-seekthru
	optfeature "search via Google" app-leechcraft/lc-pogooglue
}
