# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="false"
KDE_ORG_NAME="${PN/-common/}"
KFMIN=5.115.0
inherit ecm-common gear.kde.org

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"

RDEPEND="
	!<net-misc/kio-zeroconf-23.08.5-r2:5
	!<net-misc/kio-zeroconf-24.08.0-r1:6
"

ECM_INSTALL_FILES=(
	kdedmodule/org.kde.kdnssd.xml:\${KDE_INSTALL_DBUSINTERFACEDIR}
	kioworker/zeroconf.desktop:\${KDE_INSTALL_DATADIR}/remoteview
	org.kde.kio_zeroconf.metainfo.xml:\${KDE_INSTALL_METAINFODIR}
)
