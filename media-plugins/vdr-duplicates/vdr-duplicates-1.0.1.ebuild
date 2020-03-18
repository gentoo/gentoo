# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vdr-plugin-2

GIT_VERSION="68739fd72beb9745b3e47b9e466311ef23a8ca97"

DESCRIPTION="VDR Plugin: show duplicated records"
HOMEPAGE="https://projects.vdr-developer.org/projects/plg-duplicates/repository"
SRC_URI="https://projects.vdr-developer.org/git/vdr-plugin-duplicates.git/snapshot/vdr-plugin-duplicates-${GIT_VERSION}.tar.gz -> ${P}.tar.gz"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="GPL-2"
IUSE=""

DEPEND=">=media-video/vdr-2.4.0"

S="${WORKDIR}/vdr-plugin-duplicates-${GIT_VERSION}"
