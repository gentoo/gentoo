# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/nvdevmon/nvdevmon-0.1.2.ebuild,v 1.2 2014/03/21 18:46:46 johu Exp $

EAPI=5

inherit kde4-base

DESCRIPTION="A device monitor for NVIDIA cards"
HOMEPAGE="http://kde-look.org/content/show.php/NVidia+Device+Monitor?content=148658"
SRC_URI="http://kde-look.org/CONTENT/content-files/148658-NVidiaDeviceMonitor-${PV}.tar.gz"

LICENSE="GPL-2+"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="debug"
S="${WORKDIR}/NVidiaDeviceMonitor"

DEPEND=""
RDEPEND="
	x11-drivers/nvidia-drivers
"
