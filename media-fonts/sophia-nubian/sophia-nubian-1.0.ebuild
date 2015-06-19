# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/sophia-nubian/sophia-nubian-1.0.ebuild,v 1.1 2015/03/07 04:42:45 yngwin Exp $

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
