# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vdr-plugin-2

DESCRIPTION="VDR Plugin: DVB Frontend Status Monitor (signal strength/noise)"
HOMEPAGE="https://github.com/rofafor/vdr-plugin-femon"
SRC_URI="https://github.com/rofafor/vdr-plugin-femon/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/vdr-plugin-femon-${PV}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~arm x86"

DEPEND=">=media-video/vdr-2.4.0"
RDEPEND="${DEPEND}"

QA_FLAGS_IGNORED="
	usr/lib/vdr/plugins/libvdr-.*
	usr/lib64/vdr/plugins/libvdr-.*"
