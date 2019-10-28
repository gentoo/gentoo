# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vdr-plugin-2

DESCRIPTION="VDR Plugin: Tea clock, clock"
HOMEPAGE="http://vdr.aistleitner.info https://github.com/madmartin/vdr-clock"
SRC_URI="https://github.com/madmartin/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE=""

DEPEND=">=media-video/vdr-1.5.9"
RDEPEND="${DEPEND}"

QA_FLAGS_IGNORED="usr/lib/vdr/plugins/libvdr-.* usr/lib64/vdr/plugins/libvdr-.*"
PATCHES=( "${FILESDIR}/${P}_gettext.diff" )
S="${WORKDIR}"/"${P}"
