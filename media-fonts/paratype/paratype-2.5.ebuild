# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="ParaType font collection for languages of Russia"
HOMEPAGE="https://company.paratype.com/pt-sans-pt-serif"
SRC_URI="https://www.paratype.ru/uni/public/PTSansOFL.zip -> ${P}_Sans.zip
	https://www.paratype.ru/uni/public/PTSerifOFL.zip -> ${P}_Serif.zip
	https://www.paratype.ru/uni/public/PTMonoOFL.zip -> ${P}_Mono.zip"

S="${WORKDIR}"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="X"

BDEPEND="app-arch/unzip"

FONT_SUFFIX="ttf"
