# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit font

DESCRIPTION="Unicode font for the standardized Yi script"
HOMEPAGE="http://scripts.sil.org/SILYi_home"
SRC_URI="http://scripts.sil.org/cms/scripts/render_download.php?site_id=nrsi&format=file&media_id=NuosuSIL${PV}.zip&filename=NuosuSIL${PV}.zip -> ${P}.zip"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE=""

DEPEND="app-arch/unzip"

S="${WORKDIR}/NuosuSIL"
FONT_S="${S}"
FONT_SUFFIX="ttf"
