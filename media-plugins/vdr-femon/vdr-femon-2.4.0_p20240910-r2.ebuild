# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vdr-plugin-2

GIT_TAG="20240910"
MY_P="vdr-plugin-femon-${GIT_TAG}"
DESCRIPTION="VDR Plugin: DVB Frontend Status Monitor (signal strength/noise)"
HOMEPAGE="https://github.com/wirbel-at-vdr-portal/vdr-plugin-femon/"
SRC_URI="https://github.com/wirbel-at-vdr-portal/vdr-plugin-femon/archive/refs/tags/${GIT_TAG}.tar.gz -> ${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

DEPEND="
	dev-libs/librepfunc:=
	>=media-video/vdr-2.4.2:="
RDEPEND="${DEPEND}"

QA_FLAGS_IGNORED="
	usr/lib/vdr/plugins/libvdr-.*
	usr/lib64/vdr/plugins/libvdr-.*"
