# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P="IPAexfont${PV/.}"
inherit font

DESCRIPTION="Japanese IPA extended TrueType fonts"
HOMEPAGE="https://ipafonts.osdn.jp/"
SRC_URI="https://osdn.mirror.liquidtelecom.com/ipafonts/57330/${MY_P}.zip"
S="${WORKDIR}/${MY_P}"

LICENSE="IPAfont"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~ia64 ppc ppc64 ~s390 x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""
RESTRICT="binchecks strip test"

BDEPEND="app-arch/unzip"

FONT_CONF=( "${FILESDIR}"/66-${PN}.conf )
FONT_SUFFIX="ttf"

DOCS=( Readme_${MY_P}.txt )
