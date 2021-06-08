# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="Sans-serif font designed for literacy use"
HOMEPAGE="https://software.sil.org/andika/"
SRC_URI="https://software.sil.org/downloads/r/${PN}/${P^}.zip -> ${P}.zip"
S="${WORKDIR}/${P^}"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="amd64 arm ~arm64 x86"
IUSE=""

BDEPEND="app-arch/unzip"

FONT_SUFFIX="ttf"

DOCS=( documentation/{Andika-features.{odt,pdf},DOCUMENTATION.txt} OFL-FAQ.txt )
