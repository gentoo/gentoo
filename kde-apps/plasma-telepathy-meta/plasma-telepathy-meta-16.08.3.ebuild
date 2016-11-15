# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit kde5-meta-pkg

DESCRIPTION="Plasma Telepathy client"
HOMEPAGE="https://community.kde.org/Real-Time_Communication_and_Collaboration"

LICENSE="|| ( GPL-2 GPL-3 LGPL-2.1 )"
KEYWORDS="~amd64 ~x86"
IUSE="gstreamer nls"

[[ ${KDE_BUILD_TYPE} = live ]] && L10N_MINIMAL=${KDE_APPS_MINIMAL}

RDEPEND="
	$(add_kdeapps_dep ktp-accounts-kcm)
	$(add_kdeapps_dep ktp-approver)
	$(add_kdeapps_dep ktp-auth-handler)
	$(add_kdeapps_dep ktp-common-internals)
	$(add_kdeapps_dep ktp-contact-list)
	$(add_kdeapps_dep ktp-contact-runner)
	$(add_kdeapps_dep ktp-desktop-applets)
	$(add_kdeapps_dep ktp-filetransfer-handler)
	$(add_kdeapps_dep ktp-kded-module)
	$(add_kdeapps_dep ktp-send-file)
	$(add_kdeapps_dep ktp-text-ui)
	!kde-apps/plasma-telepathy-meta:4
	gstreamer? ( $(add_kdeapps_dep ktp-call-ui) )
	nls? ( $(add_kdeapps_dep kde-l10n '' ${L10N_MINIMAL}) )
"

pkg_postinst() {
	echo
	elog "You can configure the accounts in Plasma System Settings"
	elog "and then add the Instant Messaging plasma applet to access the contact list."
	echo
}
