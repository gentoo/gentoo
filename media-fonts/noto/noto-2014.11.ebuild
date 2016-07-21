# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit font

DESCRIPTION="Google's font family that aims to support all the world's languages"
HOMEPAGE="https://www.google.com/get/noto/"
SRC_URI="mirror://gentoo/${P}.zip"
# version number based on the timestamp of most recently updated font in the zip

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm ~arm64 x86"
IUSE=""

DEPEND="app-arch/unzip"
RESTRICT="binchecks strip"

S=${WORKDIR}
FONT_S="${S}"
FONT_SUFFIX="otf ttf"
