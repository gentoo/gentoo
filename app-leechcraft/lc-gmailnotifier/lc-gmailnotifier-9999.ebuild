# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit leechcraft

DESCRIPTION="Notifies about new mail in a GMail inbox for LeechCraft"

SLOT="0"
KEYWORDS=""
IUSE="debug +notify quark"

DEPEND="~app-leechcraft/lc-core-${PV}
	dev-qt/qtdeclarative:5[widgets]
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
"
RDEPEND="${DEPEND}
	quark? ( ~virtual/leechcraft-quark-sideprovider-${PV} )
	notify? ( ~virtual/leechcraft-notifier-${PV} )
"

REQUIRED_USE="|| ( notify quark )"
