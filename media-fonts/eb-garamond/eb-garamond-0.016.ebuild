# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="Claude Garamont's humanist typeface from the mid-16th century"
HOMEPAGE="http://www.georgduffner.at/ebgaramond/"
SRC_URI="https://bitbucket.org/georgd/eb-garamond/downloads/EBGaramond-${PV}.zip"
S="${WORKDIR}/EBGaramond-${PV}"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="amd64 arm ~arm64 x86"
IUSE=""

BDEPEND="app-arch/unzip"

FONT_SUFFIX="otf"
FONT_S="${S}/${FONT_SUFFIX}"

DOCS=( Changes README.markdown specimen/Specimen.pdf )
