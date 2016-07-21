# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit font

DESCRIPTION="Unicode sans-serif typeface for Coptic/Nubian languages"
HOMEPAGE="http://scripts.sil.org/SophiaNubian"
SRC_URI="http://scripts.sil.org/cms/scripts/render_download.php?format=file&media_id=SN${PV}.zip&filename=SN${PV}.zip -> ${P}.zip"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE=""

DEPEND="app-arch/unzip"

S="${WORKDIR}/SophiaNubian"
FONT_S="${S}"
FONT_SUFFIX="ttf"
DOCS="Readme.txt"
