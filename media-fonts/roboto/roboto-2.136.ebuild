# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit font

DESCRIPTION="Standard font for Android 4.0 (Ice Cream Sandwich) and later"
HOMEPAGE="https://github.com/google/roboto"
SRC_URI="https://github.com/google/${PN}/releases/download/v${PV}/roboto-unhinted.zip -> ${P}.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86 ~amd64-linux ~x86-linux ~x64-macos"

DEPEND="app-arch/unzip"

S=${WORKDIR}/${PN}-unhinted
FONT_S=${S}

FONT_SUFFIX="ttf"
FONT_CONF=( "${FILESDIR}"/90-roboto-regular.conf )
