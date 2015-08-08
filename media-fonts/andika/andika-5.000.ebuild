# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit font

DESCRIPTION="Sans-serif font designed for literacy use"
HOMEPAGE="http://scripts.sil.org/Andika"
SRC_URI="http://scripts.sil.org/cms/scripts/render_download.php?format=file&media_id=Andika-${PV}.zip&filename=Andika-${PV}.zip -> ${P}.zip"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="amd64 arm ~arm64 x86"
IUSE=""

DEPEND="app-arch/unzip"

S="${WORKDIR}/Andika-${PV}"
FONT_S="${S}"
FONT_SUFFIX="ttf"
DOCS="documentation/* OFL-FAQ.txt"
