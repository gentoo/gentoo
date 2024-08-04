# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

MY_P="IPAexfont${PV/.}"

DESCRIPTION="Japanese IPA extended TrueType fonts"
HOMEPAGE="https://moji.or.jp/ipafont/"
SRC_URI="https://moji.or.jp/wp-content/ipafont/IPAexfont/${MY_P}.zip"

LICENSE="IPAfont"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ~loong ppc ppc64 ~riscv ~s390 x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""
RESTRICT="binchecks strip"

BDEPEND="app-arch/unzip"
S="${WORKDIR}/${MY_P}"

DOCS=( Readme_${MY_P}.txt )

FONT_CONF=( "${FILESDIR}"/66-${PN}.conf )
FONT_SUFFIX="ttf"
