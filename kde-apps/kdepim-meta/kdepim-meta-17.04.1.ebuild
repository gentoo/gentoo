# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit kde5-meta-pkg

DESCRIPTION="KDE PIM - merge this to pull in all kdepim-derived packages"
HOMEPAGE="https://www.kde.org/applications/development"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="google"

RDEPEND="
	$(add_kdeapps_dep akonadi)
	$(add_kdeapps_dep akonadiconsole)
	$(add_kdeapps_dep akonadi-calendar)
	$(add_kdeapps_dep akonadi-contacts)
	$(add_kdeapps_dep akonadi-import-wizard)
	$(add_kdeapps_dep akonadi-mime)
	$(add_kdeapps_dep akonadi-notes)
	$(add_kdeapps_dep akonadi-search)
	$(add_kdeapps_dep akregator)
	$(add_kdeapps_dep blogilo)
	$(add_kdeapps_dep calendarjanitor)
	$(add_kdeapps_dep calendarsupport)
	$(add_kdeapps_dep eventviews)
	$(add_kdeapps_dep grantlee-editor)
	$(add_kdeapps_dep grantleetheme)
	$(add_kdeapps_dep incidenceeditor)
	$(add_kdeapps_dep kaddressbook)
	$(add_kdeapps_dep kalarm)
	$(add_kdeapps_dep kalarmcal)
	$(add_kdeapps_dep kblog)
	$(add_kdeapps_dep kcalcore)
	$(add_kdeapps_dep kcalutils)
	$(add_kdeapps_dep kcontacts)
	$(add_kdeapps_dep kdepim-addons)
	$(add_kdeapps_dep kdepim-apps-libs)
	$(add_kdeapps_dep kdepim-runtime)
	$(add_kdeapps_dep kholidays)
	$(add_kdeapps_dep kidentitymanagement)
	$(add_kdeapps_dep kimap)
	$(add_kdeapps_dep kldap)
	$(add_kdeapps_dep kleopatra)
	$(add_kdeapps_dep kmail)
	$(add_kdeapps_dep kmail-account-wizard)
	$(add_kdeapps_dep kmailtransport)
	$(add_kdeapps_dep kmbox)
	$(add_kdeapps_dep kmime)
	$(add_kdeapps_dep knotes)
	$(add_kdeapps_dep konsolekalendar)
	$(add_kdeapps_dep kontact)
	$(add_kdeapps_dep kontactinterface)
	$(add_kdeapps_dep korganizer)
	$(add_kdeapps_dep kpimtextedit)
	$(add_kdeapps_dep libgravatar)
	$(add_kdeapps_dep libkdepim)
	$(add_kdeapps_dep libkleo)
	$(add_kdeapps_dep libksieve)
	$(add_kdeapps_dep libktnef)
	$(add_kdeapps_dep mailcommon)
	$(add_kdeapps_dep mailimporter)
	$(add_kdeapps_dep mbox-importer)
	$(add_kdeapps_dep messagelib)
	$(add_kdeapps_dep pim-data-exporter)
	$(add_kdeapps_dep pim-sieve-editor)
	$(add_kdeapps_dep pimcommon)
	$(add_kdeapps_dep syndication)
	google? ( $(add_kdeapps_dep libkgapi) )
"
