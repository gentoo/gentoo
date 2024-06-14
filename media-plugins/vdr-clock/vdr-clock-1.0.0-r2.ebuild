# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vdr-plugin-2

DESCRIPTION="VDR Plugin: Tea clock, clock"
HOMEPAGE="https://github.com/madmartin/vdr-clock"
SRC_URI="https://github.com/madmartin/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/"${P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86"

DEPEND="media-video/vdr"
RDEPEND="${DEPEND}"

QA_FLAGS_IGNORED="usr/lib/vdr/plugins/libvdr-.* usr/lib64/vdr/plugins/libvdr-.*"
PATCHES=( "${FILESDIR}/${P}_gettext.diff" )
