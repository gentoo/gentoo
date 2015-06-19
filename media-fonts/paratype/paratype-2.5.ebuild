# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/paratype/paratype-2.5.ebuild,v 1.1 2014/11/29 14:23:09 zlogene Exp $

EAPI=5

inherit font

DESCRIPTION="ParaType font collection for languages of Russia"
HOMEPAGE="http://www.paratype.com/public/"
SRC_URI="http://www.paratype.ru/uni/public/PTSansOFL.zip -> ${P}_Sans.zip
	http://www.paratype.ru/uni/public/PTSerifOFL.zip -> ${P}_Serif.zip
	http://www.paratype.ru/uni/public/PTMonoOFL.zip -> ${P}_Mono.zip"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="X"

DEPEND="app-arch/unzip"
RDEPEND=""

S=${WORKDIR}
FONT_S=${WORKDIR}
FONT_SUFFIX="ttf"
