# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="KDE PIM - merge this to pull in all kdepim-derived packages"
HOMEPAGE="https://kde.org/applications/office/org.kde.kontact"

LICENSE="metapackage"
SLOT="5"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="bogofilter clamav spamassassin"

RDEPEND="
	>=kde-apps/akonadi-${PV}:${SLOT}
	>=kde-apps/akonadiconsole-${PV}:${SLOT}
	>=kde-apps/akonadi-calendar-${PV}:${SLOT}
	>=kde-apps/akonadi-contacts-${PV}:${SLOT}
	>=kde-apps/akonadi-import-wizard-${PV}:${SLOT}
	>=kde-apps/akonadi-mime-${PV}:${SLOT}
	>=kde-apps/akonadi-notes-${PV}:${SLOT}
	>=kde-apps/akonadi-search-${PV}:${SLOT}
	>=kde-apps/akregator-${PV}:${SLOT}
	>=kde-apps/calendarjanitor-${PV}:${SLOT}
	>=kde-apps/calendarsupport-${PV}:${SLOT}
	>=kde-apps/eventviews-${PV}:${SLOT}
	>=kde-apps/grantlee-editor-${PV}:${SLOT}
	>=kde-apps/grantleetheme-${PV}:${SLOT}
	>=kde-apps/incidenceeditor-${PV}:${SLOT}
	>=kde-apps/kaddressbook-${PV}:${SLOT}
	>=kde-apps/kalarm-${PV}:${SLOT}
	>=kde-apps/kalarmcal-${PV}:${SLOT}
	>=kde-apps/kcalutils-${PV}:${SLOT}
	>=kde-apps/kdepim-addons-${PV}:${SLOT}
	>=kde-apps/kdepim-apps-libs-${PV}:${SLOT}
	>=kde-apps/kdepim-runtime-${PV}:${SLOT}
	>=kde-apps/kidentitymanagement-${PV}:${SLOT}
	>=kde-apps/kimap-${PV}:${SLOT}
	>=kde-apps/kitinerary-${PV}:${SLOT}
	>=kde-apps/kldap-${PV}:${SLOT}
	>=kde-apps/kleopatra-${PV}:${SLOT}
	>=kde-apps/kmail-${PV}:${SLOT}
	>=kde-apps/kmail-account-wizard-${PV}:${SLOT}
	>=kde-apps/kmailtransport-${PV}:${SLOT}
	>=kde-apps/kmbox-${PV}:${SLOT}
	>=kde-apps/kmime-${PV}:${SLOT}
	>=kde-apps/knotes-${PV}:${SLOT}
	>=kde-apps/konsolekalendar-${PV}:${SLOT}
	>=kde-apps/kontact-${PV}:${SLOT}
	>=kde-apps/kontactinterface-${PV}:${SLOT}
	>=kde-apps/korganizer-${PV}:${SLOT}
	>=kde-apps/kpimtextedit-${PV}:${SLOT}
	>=kde-apps/kpkpass-${PV}:${SLOT}
	>=kde-apps/ksmtp-${PV}:${SLOT}
	>=kde-apps/libgravatar-${PV}:${SLOT}
	>=kde-apps/libkdepim-${PV}:${SLOT}
	>=kde-apps/libkgapi-${PV}:${SLOT}
	>=kde-apps/libkleo-${PV}:${SLOT}
	>=kde-apps/libksieve-${PV}:${SLOT}
	>=kde-apps/libktnef-${PV}:${SLOT}
	>=kde-apps/mailcommon-${PV}:${SLOT}
	>=kde-apps/mailimporter-${PV}:${SLOT}
	>=kde-apps/mbox-importer-${PV}:${SLOT}
	>=kde-apps/messagelib-${PV}:${SLOT}
	>=kde-apps/pim-data-exporter-${PV}:${SLOT}
	>=kde-apps/pim-sieve-editor-${PV}:${SLOT}
	>=kde-apps/pimcommon-${PV}:${SLOT}
	!kde-apps/kdepim-meta:4
"
# Optional runtime dependencies: kde-apps/kmail
RDEPEND="${RDEPEND}
	bogofilter? ( mail-filter/bogofilter )
	clamav? ( app-antivirus/clamav )
	spamassassin? ( mail-filter/spamassassin )
"
