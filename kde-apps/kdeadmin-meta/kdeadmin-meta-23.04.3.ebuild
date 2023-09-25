# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="KDE administration tools - merge this to pull in all kdeadmin-derived packages"
HOMEPAGE="https://apps.kde.org/"

LICENSE="metapackage"
SLOT="5"
KEYWORDS="amd64 arm64 ~ppc64 ~riscv x86"
IUSE="+cron"

RDEPEND="
	>=kde-apps/ksystemlog-${PV}:${SLOT}
	cron? ( >=kde-apps/kcron-${PV}:${SLOT} )
"
