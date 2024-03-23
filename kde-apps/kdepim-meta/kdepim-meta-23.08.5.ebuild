# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="KDE PIM - merge this to pull in all kdepim-derived packages"
HOMEPAGE="https://apps.kde.org/kontact/"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="amd64 arm64 ~ppc64 ~x86"
IUSE="bogofilter clamav spamassassin"

RDEPEND="
	>=app-office/merkuro-${PV}:5
	>=kde-apps/akonadi-${PV}:5
	>=kde-apps/akonadiconsole-${PV}:5
	>=kde-apps/akonadi-calendar-${PV}:5
	>=kde-apps/akonadi-contacts-${PV}:5
	>=kde-apps/akonadi-import-wizard-${PV}:5
	>=kde-apps/akonadi-mime-${PV}:5
	>=kde-apps/akonadi-notes-${PV}:5
	>=kde-apps/akonadi-search-${PV}:5
	>=kde-apps/akregator-${PV}:5
	>=kde-apps/calendarjanitor-${PV}:5
	>=kde-apps/calendarsupport-${PV}:5
	>=kde-apps/eventviews-${PV}:5
	>=kde-apps/grantlee-editor-${PV}:5
	>=kde-apps/grantleetheme-${PV}:5
	>=kde-apps/incidenceeditor-${PV}:5
	>=kde-apps/kaddressbook-${PV}:5
	>=kde-apps/kalarm-${PV}:5
	>=kde-apps/kcalutils-${PV}:5
	>=kde-apps/kdepim-addons-${PV}:5
	>=kde-apps/kdepim-runtime-${PV}:5
	>=kde-apps/kidentitymanagement-${PV}:5
	>=kde-apps/kimap-${PV}:5
	>=kde-apps/kitinerary-${PV}:5
	>=kde-apps/kldap-${PV}:5
	>=kde-apps/kleopatra-${PV}:5
	>=kde-apps/kmail-${PV}:5
	>=kde-apps/kmail-account-wizard-${PV}:5
	>=kde-apps/kmailtransport-${PV}:5
	>=kde-apps/kmbox-${PV}:5
	>=kde-apps/kmime-${PV}:5
	>=kde-apps/knotes-${PV}:5
	>=kde-apps/konsolekalendar-${PV}:5
	>=kde-apps/kontact-${PV}:5
	>=kde-apps/kontactinterface-${PV}:5
	>=kde-apps/korganizer-${PV}:5
	>=kde-apps/kpimtextedit-${PV}:5
	>=kde-apps/kpkpass-${PV}:5
	>=kde-apps/ksmtp-${PV}:5
	>=kde-apps/libgravatar-${PV}:5
	>=kde-apps/libkdepim-${PV}:5
	>=kde-apps/libkgapi-${PV}:5
	>=kde-apps/libkleo-${PV}:5
	>=kde-apps/libksieve-${PV}:5
	>=kde-apps/libktnef-${PV}:5
	>=kde-apps/mailcommon-${PV}:5
	>=kde-apps/mailimporter-${PV}:5
	>=kde-apps/mbox-importer-${PV}:5
	>=kde-apps/messagelib-${PV}:5
	>=kde-apps/pim-data-exporter-${PV}:5
	>=kde-apps/pim-sieve-editor-${PV}:5
	>=kde-apps/pimcommon-${PV}:5
	>=kde-misc/zanshin-${PV}:5
"
# Optional runtime dependencies: kde-apps/kmail
RDEPEND="${RDEPEND}
	bogofilter? ( mail-filter/bogofilter )
	clamav? ( app-antivirus/clamav )
	spamassassin? ( mail-filter/spamassassin )
"
