# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-leechcraft/lc-gmailnotifier/lc-gmailnotifier-9999.ebuild,v 1.1 2013/05/01 08:09:22 pinkbyte Exp $

EAPI="5"

inherit leechcraft

DESCRIPTION="Notifier about new mail in a GMail inbox for LeechCraft"

SLOT="0"
KEYWORDS=""
IUSE="debug notify quark"

DEPEND="~app-leechcraft/lc-core-${PV}
	dev-qt/qtdeclarative:4"
RDEPEND="${DEPEND}
	quark? ( ~virtual/leechcraft-quark-sideprovider-${PV} )
	notify? ( ~virtual/leechcraft-notifier-${PV} )"
