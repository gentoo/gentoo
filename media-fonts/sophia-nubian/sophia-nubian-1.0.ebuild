# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="Unicode sans-serif typeface for Coptic/Nubian languages"
HOMEPAGE="https://software.sil.org/SophiaNubian/"
SRC_URI="https://software.sil.org/downloads/r/${PN/-/}/SophiaNubian-${PV}.zip -> ${P}.zip"
S="${WORKDIR}/SophiaNubian"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE=""

BDEPEND="app-arch/unzip"

DOCS=( Readme.txt )

FONT_SUFFIX="ttf"
