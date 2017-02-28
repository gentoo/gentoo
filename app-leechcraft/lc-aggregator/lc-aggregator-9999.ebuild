# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit leechcraft

DESCRIPTION="Full-featured RSS/Atom feed reader for LeechCraft"

SLOT="0"
KEYWORDS=""
IUSE="debug mysql +sqlite postgres"

DEPEND="
	~app-leechcraft/lc-core-${PV}[postgres?,sqlite?]
	dev-qt/qtcore:5
	dev-qt/qtnetwork:5
	dev-qt/qtprintsupport:5
	dev-qt/qtsql:5[sqlite?,postgres?,mysql?]
	dev-qt/qtwebkit:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5"
RDEPEND="${DEPEND}
		virtual/leechcraft-downloader-http"

REQUIRED_USE="|| ( mysql sqlite postgres )"

pkg_postinst(){
	if use mysql; then
		ewarn "Support for MySQL databases is experimental and is more likely"
		ewarn "to contain bugs or mishandle your data than other storage"
		ewarn "backends. If you do not plan testing the MySQL storage backend"
		ewarn "itself, consider using other backends."
		ewarn "Anyway, it is perfectly safe to enable the mysql use flag as"
		ewarn "long as at least one other storage is enabled since you will"
		ewarn "be able to choose another storage backend at run time."
	fi
}
