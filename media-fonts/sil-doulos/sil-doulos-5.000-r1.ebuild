# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P="DoulosSIL-${PV}"
inherit font

DESCRIPTION="SIL font for Roman and Cyrillic Languages"
HOMEPAGE="https://software.sil.org/doulos/"
SRC_URI="https://software.sil.org/downloads/r/doulos/${MY_P}.zip -> ${P}.zip"
S="${WORKDIR}/${MY_P}"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~ia64 ppc ppc64 s390 sparc x86"
IUSE=""

BDEPEND="app-arch/unzip"

DOCS=( OFL-FAQ.txt documentation/{DOCUMENTATION.txt,DoulosSIL-features.pdf} )

FONT_SUFFIX="ttf"
