# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/kanjistrokeorders/kanjistrokeorders-2.015.ebuild,v 1.1 2010/11/04 09:15:32 matsuu Exp $

inherit font

MY_P="KanjiStrokeOrders_v${PV}"
DESCRIPTION="font to view stroke order diagrams for Kanji, Kana and etc"
HOMEPAGE="http://sites.google.com/site/nihilistorguk/"
SRC_URI="http://sites.google.com/site/nihilistorguk/Home/${MY_P}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# Only installs fonts
RESTRICT="strip binchecks"

S="${WORKDIR}"
FONT_S="${S}"

FONT_SUFFIX="ttf"
DOCS="readme_en_v${PV}.txt"
