# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

MY_P="unidic-mecab-${PV}_src"

DESCRIPTION="IPA dictionary for MeCab"
HOMEPAGE="https://osdn.jp/projects/unidic/"
SRC_URI="mirror://sourceforge.jp/unidic/58338/${MY_P}.zip"

LICENSE="|| ( BSD GPL-2 LGPL-2.1 )"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="app-text/mecab"
S="${WORKDIR}/${MY_P}"
