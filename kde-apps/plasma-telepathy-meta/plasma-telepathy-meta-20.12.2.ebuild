# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Plasma Telepathy client"
HOMEPAGE="https://community.kde.org/KTp"

LICENSE="metapackage"
SLOT="5"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE=""

RDEPEND="
	>=kde-apps/ktp-accounts-kcm-${PV}:${SLOT}
	>=kde-apps/ktp-approver-${PV}:${SLOT}
	>=kde-apps/ktp-auth-handler-${PV}:${SLOT}
	>=kde-apps/ktp-common-internals-${PV}:${SLOT}
	>=kde-apps/ktp-contact-list-${PV}:${SLOT}
	>=kde-apps/ktp-contact-runner-${PV}:${SLOT}
	>=kde-apps/ktp-desktop-applets-${PV}:${SLOT}
	>=kde-apps/ktp-filetransfer-handler-${PV}:${SLOT}
	>=kde-apps/ktp-kded-module-${PV}:${SLOT}
	>=kde-apps/ktp-send-file-${PV}:${SLOT}
	>=kde-apps/ktp-text-ui-${PV}:${SLOT}
"

pkg_postinst() {
	elog "You can configure the accounts in Plasma System Settings"
	elog "and then add the Instant Messaging plasma applet to access the contact list."
}
