# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vdr-plugin-2

# commit 2022/08/22
GITHASH="afec850e8a5ed1ad215714f26bd94ad1dd0a028a"

DESCRIPTION="VDR Plugin: permanent timeshift by recording live TV on RAM"
HOMEPAGE="https://ein-eike.de/vdr-plugin-permashift-english/"
SRC_URI="https://github.com/eikesauer/Permashift/archive/${GITHASH}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/Permashift-${GITHASH}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="|| ( ~media-video/vdr-2.2.0[permashift]
	>=media-video/vdr-2.4.1-r3[permashift]
	)"
RDEPEND="${DEPEND}"

QA_FLAGS_IGNORED="
	usr/lib/vdr/plugins/libvdr-.*
	usr/lib64/vdr/plugins/libvdr-.*"
