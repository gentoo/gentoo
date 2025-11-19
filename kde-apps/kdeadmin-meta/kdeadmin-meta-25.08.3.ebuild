# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="KDE administration tools - merge this to pull in all kdeadmin-derived packages"
HOMEPAGE="https://apps.kde.org/"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE="+cron"

RDEPEND="
	>=app-admin/kio-admin-${PV}:*
	>=kde-apps/ksystemlog-${PV}:*
	cron? ( >=kde-apps/kcron-${PV}:* )
"
