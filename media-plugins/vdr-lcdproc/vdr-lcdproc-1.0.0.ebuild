# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vdr-plugin-2

DESCRIPTION="VDR plugin: use LCD device for additional output"
HOMEPAGE="https://github.com/vdr-projects/vdr-plugin-lcdproc"
SRC_URI="https://github.com/vdr-projects/vdr-plugin-lcdproc/archive/refs/tags/${PV}.tar.gz -> ${P}.tgz"
S=${WORKDIR}/vdr-plugin-lcdproc-${PV}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="app-misc/lcdproc
	>=media-video/vdr-2.4"
RDEPEND="${DEPEND}"
