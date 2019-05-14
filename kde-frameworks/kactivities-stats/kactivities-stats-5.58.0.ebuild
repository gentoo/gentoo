# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit kde5

DESCRIPTION="Framework for getting the usage statistics collected by the activities service"
LICENSE="LGPL-2+"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE=""

RDEPEND="
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtsql)
	$(add_frameworks_dep kactivities)
	$(add_frameworks_dep kconfig)
"
DEPEND="${RDEPEND}
	>=dev-libs/boost-1.54
"
