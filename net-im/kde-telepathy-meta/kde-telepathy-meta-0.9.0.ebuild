# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/kde-telepathy-meta/kde-telepathy-meta-0.9.0.ebuild,v 1.1 2014/10/26 16:37:44 kensington Exp $

EAPI=5

DESCRIPTION="KDE Telepathy client - merge this to pull in all net-im/ktp-*
kde packages"
HOMEPAGE="http://community.kde.org/Real-Time_Communication_and_Collaboration"

if [[ ${PV} != *9999* ]]; then
	KEYWORDS="~amd64 ~x86"
else
	KEYWORDS=""
fi

LICENSE="|| ( GPL-2 GPL-3 LGPL-2.1 )"
SLOT="4"
IUSE=""

DEPEND=""
RDEPEND="
	>=net-im/ktp-accounts-kcm-${PV}
	>=net-im/ktp-approver-${PV}
	>=net-im/ktp-auth-handler-${PV}
	>=net-im/ktp-call-ui-${PV}
	>=net-im/ktp-common-internals-${PV}
	>=net-im/ktp-contact-list-${PV}
	>=net-im/ktp-contact-runner-${PV}
	>=net-im/ktp-desktop-applets-${PV}
	>=net-im/ktp-filetransfer-handler-${PV}
	>=net-im/ktp-kded-module-${PV}
	>=net-im/ktp-send-file-${PV}
	>=net-im/ktp-text-ui-${PV}
	net-im/telepathy-connection-managers
"

pkg_postinst() {
	echo
	elog "You can configure the accounts in the KDE System Settings"
	elog "and then add the Instant Messaging plasma applet to access the contact list."
	echo
}
