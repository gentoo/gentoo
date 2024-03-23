# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="KDE administration tools - merge this to pull in all kdeadmin-derived packages"
HOMEPAGE="https://apps.kde.org/"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+cron"

RDEPEND="
	>=kde-apps/ksystemlog-${PV}:*
	cron? ( >=kde-apps/kcron-${PV}:* )
"
