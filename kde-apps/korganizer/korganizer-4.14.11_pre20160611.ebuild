# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_HANDBOOK="optional"
KMNAME="kdepim"
inherit kde4-meta

DESCRIPTION="Organizational assistant, providing calendars and other similar functionality"
HOMEPAGE="https://www.kde.org/applications/office/korganizer/"

KEYWORDS="~amd64 ~arm ~x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
	$(add_kdeapps_dep kdepim-common-libs '' 4.14.11_pre20160611)
	$(add_kdeapps_dep kdepimlibs '' 4.14.11_pre20160611)
	sys-libs/zlib
"
RDEPEND="${DEPEND}
	$(add_kdeapps_dep ktimezoned '' 4.14.3)
"

RESTRICT="test"
# bug 393135

KMLOADLIBS="kdepim-common-libs"

KMEXTRA="
	korgac/
"
KMEXTRACTONLY="
	agents/mailfilteragent/org.freedesktop.Akonadi.MailFilterAgent.xml
	akonadi_next/
	calendarviews/
	kdgantt2/
	kmail/
	knode/org.kde.knode.xml
	libkdepimdbusinterfaces/
	libkleo/
	libkpgp/
	mailimporter/
	messagecomposer/
"
KMCOMPILEONLY="
	calendarsupport/
	grantleetheme/
	incidenceeditor-ng/
	kaddressbookgrantlee/
	mailcommon/
	messagecore/
	messageviewer/
	pimcommon/
	templateparser/
"

src_unpack() {
	if use kontact; then
		KMEXTRA="${KMEXTRA}
			kontact/plugins/planner/
			kontact/plugins/specialdates/
		"
	fi

	kde4-meta_src_unpack
}

src_install() {
	kde4-meta_src_install
	# colliding with kdepim-common-libs
	rm -rf "${ED}"usr/share/kde4/servicetypes/calendarplugin.desktop || die
	rm -rf "${ED}"usr/share/kde4/servicetypes/calendardecoration.desktop || die
}

pkg_postinst() {
	kde4-meta_pkg_postinst

	if ! has_version kde-apps/kdepim-kresources:${SLOT}; then
		echo
		elog "For groupware functionality, please install kde-apps/kdepim-kresources:${SLOT}"
		echo
	fi
}
