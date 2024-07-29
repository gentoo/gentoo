# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vdr-plugin-2

DESCRIPTION="VDR Plugin: DVD-Player"
HOMEPAGE="https://github.com/vdr-projects/vdr-plugin-dvd"
SRC_URI="https://github.com/vdr-projects/vdr-plugin-dvd/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/vdr-plugin-dvd-${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="media-video/vdr
	media-libs/libdvdnav
	media-libs/a52dec"
RDEPEND="${DEPEND}"

# vdr-plugin-2.eclass fix
KEEP_I18NOBJECT="yes"

PATCHES=(
	"${FILESDIR}/${PN}-0.3.7.patch"
	)
