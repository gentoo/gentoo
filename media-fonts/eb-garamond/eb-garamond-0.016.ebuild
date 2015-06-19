# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/eb-garamond/eb-garamond-0.016.ebuild,v 1.2 2015/04/28 09:47:10 yngwin Exp $

EAPI=5
inherit font

DESCRIPTION="Claude Garamont's humanist typeface from the mid-16th century"
HOMEPAGE="http://www.georgduffner.at/ebgaramond/"
SRC_URI="https://bitbucket.org/georgd/eb-garamond/downloads/EBGaramond-${PV}.zip"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="amd64 arm ~arm64 x86"
IUSE=""

DEPEND="app-arch/unzip"

S="${WORKDIR}/EBGaramond-${PV}"
FONT_SUFFIX="otf"
FONT_S="${S}/${FONT_SUFFIX}"
DOCS="Changes README.markdown specimen/Specimen.pdf"
