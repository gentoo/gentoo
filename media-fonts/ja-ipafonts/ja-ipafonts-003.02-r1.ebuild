# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit font

MY_P="IPAfont${PV/.}"

DESCRIPTION="TrueType fonts developed by Japanese Information-technology Promotion Agency"
HOMEPAGE="http://ipafont.ipa.go.jp/"
SRC_URI="http://dl.ipafont.ipa.go.jp/IPAfont/${MY_P}.zip"

LICENSE="IPAfont"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 s390 sh x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE=""
RESTRICT="binchecks strip"

DEPEND="app-arch/unzip"
RDEPEND=""
S="${WORKDIR}/${MY_P}"

FONT_SUFFIX="ttf"
FONT_S="${S}"
FONT_CONF=( "${FILESDIR}"/66-${PN}.conf )

DOCS=( "Readme_${MY_P}.txt" )
